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
	game.rng.seed = 4242
	return game
func check() -> void:
	var module = load("res://scripts/local_metrics.gd").new()
	for i in 300: module.record("investment", {"cost": i})
	module.record("not_allowed", {})
	module.record("first_staff", {}, true)
	module.record("first_staff", {}, true)
	expect(module.events.size() == 128 and module.counts["investment"] == 300 and module.counts["first_staff"] == 1 and not module.counts.has("not_allowed"), "Local journal must be bounded, allowlisted and keep cumulative/first counts")
	var restored = load("res://scripts/local_metrics.gd").new()
	restored.restore(JSON.parse_string(JSON.stringify(module.to_save())))
	expect(restored.events.size() == 128 and restored.counts == module.counts and equivalent(restored.firsts, module.firsts), "Journal restore must retain bounded events and first milestones")
	restored.next_run()
	restored.record("first_staff", {}, true)
	expect(restored.counts["first_staff"] == 2 and equivalent(restored.firsts["first_staff"], module.firsts["first_staff"]), "New run must reset only run flags, not lifetime firsts/counts")
	var a = fresh()
	var b = fresh()
	a._advance_simulation(600)
	for i in 1200: b._advance_simulation(0.5)
	var big: Dictionary = a.local_metrics.firsts["team_unlocked"]
	var small: Dictionary = b.local_metrics.firsts["team_unlocked"]
	expect(absf(float(big["run_simulation_seconds"]) - float(small["run_simulation_seconds"])) < 0.0001 and float(big["run_simulation_seconds"]) < 600, "Milestones must use event time, not the end of a large offline batch")
	expect(absf(a.local_metrics.total_seconds - 600) < 0.0001 and a.money == b.money, "Observational metrics must not change simulation money or elapsed accounting")
	a.money = 0
	var count_before: int = a.local_metrics.counts.get("investment", 0)
	a._buy_service()
	expect(int(a.local_metrics.counts.get("investment", 0)) == count_before, "Failed purchase must not count as a meaningful decision")
	a.money = 100
	a._buy_service()
	expect(a.local_metrics.counts["investment"] == count_before + 1 and a.money == 0, "Successful purchase must record once without awarding currency")
	a.last_saved_at = int(Time.get_unix_time_from_system()) - 20000
	var before_cash: int = a.money
	var income: int = a._apply_offline_income()
	var row: Dictionary = a.local_metrics.firsts["offline_return"]["values"]
	expect(a.money - before_cash == income and int(row["income"]) == income and int(row["accounted_seconds"]) == 14400 and row["capped"], "Offline event must match actual capped credited income")
	var before_visits: int = a.local_metrics.counts.get("offline_return", 0)
	a._apply_offline_income()
	expect(a.local_metrics.counts["offline_return"] == before_visits, "Repeated resume must not manufacture a return milestone")
	a._confirm_rebirth()
	a.rebirth_dialog.hide()
	expect(not a.local_metrics.counts.has("prestige"), "Preview must not record a completed prestige")
	a.run_earned = a.REBIRTH_THRESHOLD
	a._update_district()
	a._activate_district(6)
	a._rebirth()
	expect(a.local_metrics.counts["prestige"] == 1 and a.local_metrics.run_seconds == 0, "Prestige metric must commit once and reset run clock")
	a._rebirth()
	expect(a.local_metrics.counts["prestige"] == 1, "Duplicate prestige must not affect local counts")
	a.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	a._save_game()
	var snapshot: Dictionary = a.local_metrics.to_save()
	a.free()
	var resumed = load("res://scenes/Main.tscn").instantiate()
	root.add_child(resumed)
	resumed.set_process(false)
	expect(equivalent(resumed.local_metrics.to_save(), snapshot), "Restart must not fabricate events")
	resumed._reset_progress()
	expect(resumed.local_metrics.events.is_empty() and resumed.local_metrics.coverage == "new_game", "Explicit full reset must clear local playtest data")
	# Preserve the previously earned 500-coin unlock despite the new 550 target.
	var old: Dictionary = resumed._save_data().duplicate(true)
	old["economy_version"] = 4
	old["save_version"] = 5
	old["money"] = 345
	old["run_earned"] = 525
	old["total_earned"] = 525
	old["unlocked_district_index"] = 0
	old["last_saved_at"] = int(Time.get_unix_time_from_system()) + 60
	old.erase("local_metrics")
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(old))
	file.close()
	var migrated = load("res://scenes/Main.tscn").instantiate()
	root.add_child(migrated)
	migrated.set_process(false)
	expect(migrated.unlocked_district_index == 1 and migrated.district_index == 0 and migrated.money == 345 and migrated.total_earned == 525, "A8 migration must preserve prior unlock and cash without auto-activation")
	expect(migrated.local_metrics.coverage == "since_upgrade" and not migrated.local_metrics.firsts.has("automation_started"), "Legacy records must not fabricate historical onboarding metrics")
	migrated.free()
	resumed.free()
	b.free()
	if failures.is_empty(): print("Balance metrics passed: bounded local observations, exact event clock, no rewards, purchase/return/prestige counts, persistence/reset and earned-unlock migration")
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

