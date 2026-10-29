extends SceneTree
var failures: Array[String] = []
func _initialize() -> void:
	call_deferred("check")
func expect(ok: bool, reason: String) -> void:
	if not ok:
		failures.append(reason)
		push_error(reason)
func fresh() -> Control:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._reset_progress()
	game._start_playing()
	return game
func check() -> void:
	var game = fresh()
	expect(game.album_unlocked == [0] and game.unlocked_district_index == 0, "Fresh album must include only starter district")
	game._activate_district(1)
	expect(game.district_index == 0, "Locked district must reject activation")
	game._credit(game.DISTRICT_THRESHOLDS[1])
	expect(game.district_index == 0 and game.unlocked_district_index == 1 and game.album_unlocked == [0], "Unlock must not activate district or grant its postcard")
	game.dispatch.pending.append(game._make_company_order())
	var active_before: Array = game.dispatch.active.duplicate(true)
	var pending_before: Array = game.dispatch.pending.duplicate(true)
	game.dispatch.arrival_elapsed = 10.0
	var rng_before := str(game.rng.state)
	var preview: Dictionary = game._production_snapshot(-1, -1, -1, 1)
	expect(absf(float(preview["founder_seconds"]) - 38.88) < 0.001 and preview["demand"] == 5.0, "Beykoz preview must include real longer route and traffic")
	expect(game.district_index == 0 and str(game.rng.state) == rng_before, "Preview must not mutate active district or future orders")
	var current_income: float = game._production_snapshot()["income"]
	expect(float(preview["income"]) < current_income, "Higher demand must not imply a hidden universal income increase")
	game._activate_district(1)
	var fee_sum := 0.0
	var duration_sum := 0.0
	var pair_count := 0
	for pickup in game.PICKUPS.size():
		for drop in game.DROPS.size():
			if game._pickup_position(pickup) == game._drop_position(drop): continue
			var accepted: Dictionary = game._order_quote(pickup, drop)
			fee_sum += float(accepted["paid"])
			duration_sum += game.dispatch.delivery_seconds(game.vehicle, 1, float(accepted["work_distance"]))
			pair_count += 1
	expect(absf(fee_sum / pair_count - float(preview["mean_pay"])) < 0.001 and absf(duration_sum / pair_count - float(preview["founder_seconds"])) < 0.001, "Preview must match actual average locked quotes and service durations")
	expect(game.dispatch.active == active_before and game.dispatch.pending == pending_before, "District activation must preserve accepted jobs including remaining time")
	expect(absf(game.dispatch.arrival_elapsed - 6.0) < 0.001 and str(game.rng.state) == rng_before, "Switch must preserve arrival fraction without generating free orders")
	expect(game.album_unlocked == [0, 1] and game.road_district_index == 1, "First activation must grant one postcard and switch map")
	var quote: Dictionary = game._order_quote(0, 1)
	expect(quote["district"] == 1 and float(quote["work_distance"]) != float(pending_before[0]["work_distance"]), "New orders must use selected district profile")
	for i in 10:
		game._activate_district(0)
		game._activate_district(1)
	expect(game.album_unlocked.size() == 2 and game.dispatch.active == active_before and game.dispatch.pending == pending_before and absf(game.dispatch.arrival_elapsed - 6.0) < 0.001, "Repeated switches must not farm orders, reset jobs or duplicate postcards")
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 14400
	game._apply_offline_income()
	expect(game.district_index == 1 and game.unlocked_district_index > 1 and game.album_unlocked.size() == 2, "Offline unlock must not auto-activate or grant unvisited postcards")
	game.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	game._save_game()
	var saved_money: int = game.money
	game.free()
	game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	expect(game.money == saved_money and game.district_index == 1 and game.album_unlocked == [0, 1], "Selected district and permanent discoveries must survive restart")
	game._reset_progress()
	expect(game.album_unlocked == [0] and game.unlocked_district_index == 0, "Explicit total reset must clear album and district access")
	game.free()
	# Same pre-A6 state and elapsed interval: original auto-switch/300-distance model.
	var reference = fresh()
	reference.simulation_economy_version = 2
	reference.district_index = 1
	reference._build_roads()
	reference.money = 345
	reference.total_earned = 7900
	reference.run_earned = 7900
	reference.company = true
	reference.workers = 1
	reference.staff_counts.assign([1, 0, 0, 0])
	reference.dispatch.reset()
	reference.carrying = false
	reference._seed_founder_job()
	var old := {"save_version": 3, "economy_version": 2, "started": true, "money": 345, "total_earned": 7900, "run_earned": 7900, "district_index": 1, "company": true, "staff_counts": [1, 0, 0, 0], "vehicle": 0, "dispatch": reference.dispatch.to_save().duplicate(true), "rng_state": str(reference.rng.state), "last_saved_at": int(Time.get_unix_time_from_system()) - 600}
	reference._advance_simulation(600)
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(old))
	file.close()
	var migrated = load("res://scenes/Main.tscn").instantiate()
	root.add_child(migrated)
	migrated.set_process(false)
	expect(migrated.money == reference.money and migrated.total_earned == reference.total_earned and equivalent(migrated.dispatch.to_save(), reference.dispatch.to_save()), "V2 absence must settle under original economy before A6 migration, without refunding again")
	expect(migrated.district_index == reference.district_index and migrated.album_unlocked.size() == reference.district_index + 1 and migrated.unlocked_district_index >= migrated.district_index, "Legacy visited districts must migrate without granting merely newly unlocked postcards")
	migrated._dismiss_migration_notice()
	migrated.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	migrated._save_game()
	var again = load("res://scenes/Main.tscn").instantiate()
	root.add_child(again)
	again.set_process(false)
	expect(again.money == migrated.money and again.album_unlocked == migrated.album_unlocked and again.migration_notice.is_empty(), "Repeated load must not repeat migration awards or notice")
	reference.free()
	migrated.free()
	again.free()
	old["rebirth_count"] = 2
	old["run_earned"] = 0
	old["district_index"] = 0
	old["last_saved_at"] = int(Time.get_unix_time_from_system()) + 60
	file = FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(old))
	file.close()
	var veteran = load("res://scenes/Main.tscn").instantiate()
	root.add_child(veteran)
	veteran.set_process(false)
	expect(veteran.album_unlocked.size() == 7 and veteran.rebirth_count == 2 and veteran.money == 345, "Legacy completed tours must retain all discovered postcards without granting capital or another company refund")
	veteran.free()
	if failures.is_empty(): print("District choice passed: manual activation, locked jobs, pure preview, no switching farm, offline unlock, album persistence/reset and exact v2 migration")
	quit(0 if failures.is_empty() else 1)

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

