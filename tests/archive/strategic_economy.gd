extends SceneTree

var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("run_check")

func expect(condition: bool, reason: String) -> void:
	if not condition:
		failures.append(reason)
		push_error(reason)

func fresh_game() -> Control:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._reset_progress()
	game.rng.seed = 4242
	game._start_playing()
	return game

func strategy(name: String, actions: Array[String]) -> void:
	var game = fresh_game()
	var index := 0
	var times: Array[float] = []
	for step in 1200:
		game._advance_simulation(0.5)
		if index >= actions.size(): continue
		var action := actions[index]
		var choice: Dictionary = game._investment(action, 0)
		if game.money < int(choice["cost"]) or (action == "worker" and not game.company): continue
		if action == "vehicle": game._buy_vehicle()
		elif action == "service": game._buy_service()
		else: game._hire_worker(0)
		times.append((step + 1) * 0.5)
		index += 1
	expect(index == actions.size(), "Strategy could not make its three investments in 10 minutes: " + name)
	print("A3 strategy %s: buys at seconds %s; turnover %d; cash %d; founder %d; team %d; queue %d" % [name, str(times), game.total_earned, game.money, game.deliveries, game.dispatch.completed, game.dispatch.pending.size()])
	game.queue_free()

func run_check() -> void:
	var game = fresh_game()
	expect(game.money == 60 and game.total_earned == 0 and game.service_level == 0, "Starting capital must not count as earned revenue")
	var base: Dictionary = game._production_snapshot()
	expect(absf(float(base["capacity"]) - 2.0) < 0.001 and float(base["demand"]) == 3.0, "Starter demand and capacity are inconsistent")
	expect(float(game._investment("vehicle")["gain"]) > 0 and float(game._investment("service")["gain"]) > 0, "Both initial investment paths must be meaningful")
	var job: Dictionary = game.dispatch.founder_job()
	var original_paid: int = job["founder_paid"]
	var original_remaining: float = job["remaining"]
	game.money = 1000
	game._buy_service()
	expect(game.service_level == 1 and game.money == 900 and int(job["founder_paid"]) == original_paid, "Service purchase changed an accepted price or cost")
	var service_quote: Dictionary = game._order_quote(1, 2)
	game._buy_vehicle()
	expect(game.vehicle == 1 and game.money == 800 and float(job["remaining"]) == original_remaining, "Vehicle purchase changed an active job or wrong price")
	expect(int(service_quote["paid"]) == int(game._order_quote(1, 2)["paid"]), "Vehicle must not also multiply the per-order reward")
	expect(absf(float(game._production_snapshot()["founder_seconds"]) - 24.0) < 0.001, "Bike capacity preview does not match normalized routes")
	game.deliveries = 5
	game._maybe_unlock_team()
	game._hire_worker(0)
	expect(game.company and game.staff_counts[0] == 1 and game.money == 650 and game._staff_cost(0) == 240, "Early staff unlock or exponential hiring cost is wrong")
	var supplied: Dictionary = game._production_snapshot()
	expect(float(supplied["capacity"]) == 4.5 and supplied["bottleneck"] == "Talep sınırlı", "Oversupplied company must identify demand as the constraint")
	expect(float(game._investment("vehicle")["gain"]) == 0.0 and float(game._investment("worker", 0)["gain"]) == 0.0 and float(game._investment("service")["gain"]) > 0.0, "Advisor recommends idle capacity or misses service value")
	game.dispatch.pending.append(game._make_company_order())
	expect(game._production_snapshot()["bottleneck"] == "Kuyruk eriyor", "Backlog clearing must differ from steady-state demand limitation")
	expect(game.Economy.service_cost(0) == 100 and game.Economy.service_cost(1) == 155 and game.Economy.service_cost(2) == 241 and game.Economy.hire_cost(0, 2) == 384, "Service cost curve is wrong")
	game.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	game._save_game()
	var resumed = load("res://scenes/Main.tscn").instantiate()
	root.add_child(resumed)
	resumed.set_process(false)
	expect(resumed.money == 650 and resumed.service_level == 1 and resumed.staff_counts[0] == 1 and resumed.migration_notice.is_empty(), "New economy restart loses upgrades or grants a second refund")
	# Reconstruct the same pre-A3 record to measure its old interval exactly.
	var reference = fresh_game()
	reference.simulation_economy_version = 1
	reference.money = 320
	reference.total_earned = 0
	reference.run_earned = 0
	reference.company = true
	reference.workers = 1
	reference.staff_counts.assign([1, 0, 0, 0])
	reference.dispatch.reset()
	reference.carrying = false
	reference.order_payout = 42
	reference._seed_founder_job(true)
	var old := {"save_version": 2, "economy_version": 1, "started": true, "money": 320, "total_earned": 0, "run_earned": 0, "company": true, "staff_counts": [1, 0, 0, 0], "vehicle": 0, "dispatch": reference.dispatch.to_save().duplicate(true), "rng_state": str(reference.rng.state), "last_saved_at": int(Time.get_unix_time_from_system()) - 600}
	reference._advance_simulation(600.0)
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(old))
	file.close()
	var migrated = load("res://scenes/Main.tscn").instantiate()
	root.add_child(migrated)
	migrated.set_process(false)
	expect(migrated.money == reference.money + 9000 and migrated.total_earned == reference.total_earned and migrated.run_earned == reference.run_earned, "Migration must settle old time under old rules and refund company without inflating turnover")
	expect(not migrated.migration_notice.is_empty(), "Migration must explain the refund")
	migrated._dismiss_migration_notice()
	migrated.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	migrated._save_game()
	var again = load("res://scenes/Main.tscn").instantiate()
	root.add_child(again)
	again.set_process(false)
	expect(again.money == migrated.money and again.migration_notice.is_empty(), "Company refund or migration notice repeats after acknowledgement")
	strategy("vehicle-first", ["vehicle", "service", "worker"])
	strategy("service-first", ["service", "worker", "vehicle"])
	strategy("team-first", ["worker", "service", "vehicle"])
	if failures.is_empty(): print("Strategic economy passed: independent investments, bottlenecks, locked jobs, curves, migration and three strategies")
	quit(0 if failures.is_empty() else 1)
