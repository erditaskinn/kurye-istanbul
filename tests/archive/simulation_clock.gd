extends SceneTree

var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("run_check")

func expect(value: bool, reason: String) -> void:
	if not value:
		failures.append(reason)
		push_error(reason)

func equivalent(a: Variant, b: Variant) -> bool:
	if (a is float or a is int) and (b is float or b is int):
		return absf(float(a) - float(b)) < 0.0001
	if a is Dictionary and b is Dictionary:
		if a.size() != b.size(): return false
		for key in a:
			if not b.has(key) or not equivalent(a[key], b[key]): return false
		return true
	if a is Array and b is Array:
		if a.size() != b.size(): return false
		for i in a.size():
			if not equivalent(a[i], b[i]): return false
		return true
	return a == b

func engine_run(steps: Array, restart_at: int = -1) -> Dictionary:
	var model = load("res://scripts/dispatch.gd").new()
	var rng := RandomNumberGenerator.new()
	rng.seed = 424242
	var cash := [0]
	var seen := {}
	var make_order := func() -> Dictionary:
		var id := str(rng.state)
		return {"id": id, "pickup": 0, "drop": 1, "distance": rng.randi_range(100, 700), "payout": 42, "paid": 42, "founder_paid": 54, "district": 6}
	var completed := func(job: Dictionary) -> void:
		expect(not seen.has(job["id"]), "An order was paid twice")
		seen[job["id"]] = true
		cash[0] += int(job["founder_paid"]) if int(job["role"]) == 4 else int(job["paid"])
	var counts: Array[int] = [2, 1, 1, 0]
	for i in steps.size():
		model.advance(float(steps[i]), counts, 6, make_order, 2, completed)
		if i == restart_at:
			var saved: Dictionary = JSON.parse_string(JSON.stringify(model.to_save()))
			model = load("res://scripts/dispatch.gd").new()
			model.restore(saved)
	return {"state": model.to_save(), "cash": cash[0], "rng": str(rng.state)}

func setup_game() -> Control:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._reset_progress()
	game._start_playing()
	game.money = 200
	game.total_earned = 2400
	game.run_earned = 2400
	game.company = true
	game.staff_counts.assign([1, 1, 0, 0])
	game.workers = 2
	game.rng.seed = 12345
	game.dispatch.reset()
	game.pickup_index = 0
	game.drop_index = 1
	game.carrying = false
	game.order_payout = game._calculate_payout(0, 1)
	game._seed_founder_job()
	return game

func run_check() -> void:
	var fine: Array = []
	fine.resize(6000)
	fine.fill(0.1)
	var whole := engine_run([600.0])
	expect(equivalent(whole, engine_run(fine)), "Whole and 0.1 second event clocks diverge")
	expect(equivalent(whole, engine_run([95.0, 105.0, 0.125, 399.875], 1)), "Irregular steps or JSON restart lose time/RNG/order state")
	var hour := engine_run([14400.0])
	expect(equivalent(hour, engine_run([3600.0, 3600.0, 3600.0, 3600.0], 1)), "Four-hour event simulation diverges across restart")
	var a = setup_game()
	var b = setup_game()
	var c = setup_game()
	a._advance_simulation(600.0)
	b.last_saved_at = int(Time.get_unix_time_from_system()) - 600
	var income: int = b._apply_offline_income()
	for i in 6000:
		c._process(0.1)
	expect(a.money == b.money and a.money == c.money and income == b.money - 200, "Online/process and offline money differ")
	expect(equivalent(a.dispatch.to_save(), b.dispatch.to_save()) and equivalent(a.dispatch.to_save(), c.dispatch.to_save()), "Online/offline queues or jobs differ")
	expect(a.district_index == 0 and b.district_index == 0 and a.unlocked_district_index == b.unlocked_district_index and a.unlocked_district_index > 0 and str(a.rng.state) == str(b.rng.state), "District crossing or future order stream diverges")
	var cash_before: int = b.money
	b._apply_offline_income()
	expect(b.money == cash_before, "Repeated resume credits the same interval twice")
	b.last_saved_at = int(Time.get_unix_time_from_system()) + 3600
	b._apply_offline_income()
	expect(b.money == cash_before and b.last_saved_at > int(Time.get_unix_time_from_system()), "Clock rollback reopens a consumed interval")
	a.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	a._save_game()
	var resumed = load("res://scenes/Main.tscn").instantiate()
	root.add_child(resumed)
	resumed.set_process(false)
	expect(a.money == resumed.money and equivalent(a.dispatch.to_save(), resumed.dispatch.to_save()) and str(a.rng.state) == str(resumed.rng.state), "Main game restart loses active jobs or RNG")
	a._advance_simulation(60.0)
	resumed._advance_simulation(60.0)
	expect(a.money == resumed.money and equivalent(a.dispatch.to_save(), resumed.dispatch.to_save()), "Restart changes future income")
	var d = setup_game()
	var e = setup_game()
	d._advance_simulation(14400.0)
	e.last_saved_at = int(Time.get_unix_time_from_system()) - 20000
	e._apply_offline_income()
	expect(d.money == e.money and int(e.return_summary["seconds"]) == 14400 and int(e.return_summary["capped"]) == 1, "Offline cap differs from exactly four hours of simulation")
	# Existing v0 progress receives the old solo tariff once, then joins v1.
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"money": 320, "total_earned": 1860, "vehicle": 1, "company": false, "carrying": true, "pickup_index": 2, "drop_index": 3, "order_payout": 42, "last_saved_at": int(Time.get_unix_time_from_system()) - 600}))
	file.close()
	var legacy = load("res://scenes/Main.tscn").instantiate()
	root.add_child(legacy)
	legacy.set_process(false)
	expect(legacy.money == 390 and legacy.dispatch.founder_job().size() > 0 and legacy.order_payout == 42 and legacy.carrying, "Legacy settlement or accepted founder order is lost")
	expect(legacy.dispatch.active.size() == 1, "Restart injected duplicate founder jobs")
	# Matched reference fixture: 300 units, 42 TRY, district 0, one staff + founder.
	var old = load("res://scripts/legacy_dispatch.gd").new()
	var modern = load("res://scripts/dispatch.gd").new()
	var counts: Array[int] = [1, 0, 0, 0]
	var make := func() -> Dictionary: return {"pickup": 0, "drop": 1, "distance": 300.0, "payout": 42, "paid": 42, "founder_paid": 42, "district": 0}
	var seed_job: Dictionary = make.call()
	seed_job.merge({"role": 4, "slot": 0, "remaining": 95.0, "duration": 95.0, "pickup_seconds": 20.0})
	modern.active.append(seed_job)
	var old_cash := 50 # v0 solo offline tariff: 5 TRY/minute.
	for i in 40:
		for job in old.advance(15.0, counts, 0, make):
			old_cash += int(job["payout"])
	var new_jobs: Array[Dictionary] = modern.advance(600.0, counts, 0, make, 0, Callable(), Callable(), modern.Economy.LEGACY_DEMAND)
	var new_cash := 0
	for job in new_jobs:
		new_cash += int(job["payout"])
	expect(old_cash == 260, "Legacy comparison fixture drifted")
	print("A2 600s reference (300 distance, 42 TRY, one founder + one staff): v0 offline %d TRY; v1 shared %d TRY (%d founder, %d staff)" % [old_cash, new_cash, modern.founder_completed, modern.completed])
	# Jobs waiting through an upgrade/region change retain the acceptance quote.
	var frozen = load("res://scripts/dispatch.gd").new()
	var accepted: Dictionary = make.call()
	frozen.pending.append(accepted)
	var no_staff: Array[int] = [0, 0, 0, 0]
	frozen.advance(0.0, no_staff, 6, make, 3)
	var assigned: Dictionary = frozen.founder_job()
	expect(int(assigned["district"]) == 0 and int(assigned["founder_paid"]) == 42 and absf(float(assigned["duration"]) - (20.0 + 300.0 / frozen.Economy.LEGACY_ROLE_SPEED[3])) < 0.001, "A queued job was repriced or used the new district's traffic")
	if failures.is_empty():
		print("Simulation clock passed: step invariance, restart, four-hour cap, dynamic districts, online/offline parity, migration and no duplicate credit")
	quit(0 if failures.is_empty() else 1)
