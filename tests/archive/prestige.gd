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
func eligible(game: Control) -> void:
	game.run_earned = game.REBIRTH_THRESHOLD
	game._update_district()
	game._activate_district(6)
func check() -> void:
	var game = fresh()
	var before: Dictionary = game._save_data().duplicate(true)
	game._confirm_rebirth()
	expect(game.rebirth_dialog.visible and game.rebirth_dialog.get_ok_button().disabled and "+25%" in game.rebirth_dialog.dialog_text, "Locked preview must show benefit without allowing reset")
	game.rebirth_dialog.hide()
	game.rebirth_dialog.canceled.emit()
	expect(game._save_data() == before, "Preview and cancellation must not change persistent progress or RNG")
	game._rebirth()
	expect(game.rebirth_count == 0 and game.money == 60, "Direct reset must also enforce eligibility")
	eligible(game)
	game.money = 4321
	game.total_earned = 777777
	game.vehicle = 2
	game.service_level = 3
	game.company = true
	game.workers = 2
	game.staff_counts.assign([1, 1, 0, 0])
	game.guide_seen = true
	for i in 7: game._collect_district(i)
	game.dispatch.pending.append(game._make_company_order())
	game.return_summary = {"seconds": 600, "solo": 200, "team": 100, "completed": 2, "capped": 0}
	game.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	game._save_game()
	before = game._save_data().duplicate(true)
	var file_before := FileAccess.get_file_as_string(game.SAVE_PATH)
	var store = game.save_store
	game.save_store = load("res://tests/failing_save_store.gd").new()
	game._rebirth()
	expect(game._save_data() == before and FileAccess.get_file_as_string(game.SAVE_PATH) == file_before, "Storage failure must not reset runtime, grant reputation or replace saved progress")
	game.save_store = store
	game._confirm_rebirth()
	expect(not game.rebirth_dialog.get_ok_button().disabled and game.Numbers.compact(777777) in game.rebirth_dialog.dialog_text and "7/7" in game.rebirth_dialog.dialog_text, "Eligible preview must show retained real progress")
	game._rebirth()
	expect(game.rebirth_count == 1 and game.money == 60 and game.run_earned == 0 and game.total_earned == 777777, "New run must award once, retain lifetime turnover and exclude capital from revenue")
	expect(game.vehicle == 0 and game.service_level == 0 and game.staff_counts == [0, 0, 0, 0] and not game.company and game.district_index == 0 and game.unlocked_district_index == 0, "Run economy and district access must reset")
	expect(game.album_unlocked.size() == 7 and game.guide_seen and game.return_summary.is_empty() and game.dispatch.pending.is_empty() and game.dispatch.active.size() == 1, "Permanent discoveries/guide must stay while old jobs/summary are cleared")
	var saved: Dictionary = game.save_store.load_record(game.SAVE_PATH)
	expect(saved["rebirth_count"] == 1 and saved["money"] == 60 and equivalent(saved["dispatch"], game.dispatch.to_save()) and saved["rng_state"] == str(game.rng.state), "Disk transaction must contain complete new run, including starter job and RNG")
	var after_file := FileAccess.get_file_as_string(game.SAVE_PATH)
	game._rebirth()
	expect(game.rebirth_count == 1 and FileAccess.get_file_as_string(game.SAVE_PATH) == after_file, "Repeated confirmation must not award twice")
	game.free()
	game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	expect(game.rebirth_count == 1 and game.money == 60 and game.album_unlocked.size() == 7 and game._income_multiplier() == 1.25, "Immediate restart must restore the committed new run")
	eligible(game)
	game._rebirth()
	expect(game.rebirth_count == 2 and game._income_multiplier() == 1.5, "Second tour must add 25 percentage points instead of compounding")
	game.free()
	# Old A6 bonus and elapsed interval are settled before changing future quotes.
	var reference = fresh()
	reference.simulation_economy_version = 3
	reference.rebirth_count = 2
	reference.service_level = 2
	reference.money = 300
	reference.company = true
	reference.workers = 1
	reference.staff_counts.assign([1, 0, 0, 0])
	reference.dispatch.reset()
	reference._seed_founder_job()
	var old: Dictionary = reference._save_data().duplicate(true)
	old["economy_version"] = 3
	old["save_version"] = 4
	old["last_saved_at"] = int(Time.get_unix_time_from_system()) - 600
	reference._advance_simulation(600)
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(old))
	file.close()
	var migrated = load("res://scenes/Main.tscn").instantiate()
	root.add_child(migrated)
	migrated.set_process(false)
	expect(migrated.money == reference.money and migrated.total_earned == reference.total_earned and equivalent(migrated.dispatch.to_save(), reference.dispatch.to_save()), "A6 absence must use original 10-point bonus and preserve accepted jobs")
	expect(migrated.rebirth_count == 2 and migrated._income_multiplier() == 1.5 and "+20%" in migrated.migration_notice and "+50%" in migrated.migration_notice, "Migration must preserve reputation count and explain bonus conversion")
	var old_quote: Dictionary = reference._order_quote(0, 1)
	var new_quote: Dictionary = migrated._order_quote(0, 1)
	expect(int(new_quote["paid"]) > int(old_quote["paid"]), "Converted reputation must benefit future accepted jobs")
	migrated._dismiss_migration_notice()
	migrated.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	migrated._save_game()
	var again = load("res://scenes/Main.tscn").instantiate()
	root.add_child(again)
	again.set_process(false)
	expect(again.money == migrated.money and again.rebirth_count == 2 and again.migration_notice.is_empty(), "Restart must not repeat migration, credit or award")
	reference.free()
	migrated.free()
	again.free()
	if failures.is_empty(): print("Prestige passed: locked/eligible preview, cancel, failed storage safety, one transaction, no duplicate award, permanent/reset fields and exact A6 bonus migration")
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

