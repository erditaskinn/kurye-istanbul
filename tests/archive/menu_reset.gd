extends SceneTree

func _initialize() -> void:
	call_deferred("run_check")

func run_check() -> void:
	var old_save := {"money": 5000, "total_earned": 12000, "run_earned": 12000, "district_index": 2, "vehicle": 2, "company": true, "staff_counts": [2, 0, 0, 0], "deliveries": 65, "last_saved_at": int(Time.get_unix_time_from_system())}
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	if file == null:
		_fail("Could not write legacy save")
		return
	file.store_string(JSON.stringify(old_save))
	file.close()
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	if not game.menu_overlay.visible or not game.has_started or game.menu_start_button.text != "DEVAM ET" or game.money != 14000:
		_fail("Legacy progress did not open in Continue menu")
		return
	root.size = Vector2i(480, 1040)
	await process_frame
	if game.menu_overlay.size.y < 1000 or game.settings_overlay.size.y < 1000 or game.menu_start_button.position.y < 500:
		_fail("Entry menu did not fill and center on a tall phone")
		return
	var deliveries_before: int = game.deliveries
	game._process(60.0)
	if game.deliveries != deliveries_before or game.dispatch.completed != 0:
		_fail("Game simulation continued behind the menu")
		return
	game._start_playing()
	if game.migration_dialog.visible:
		game._dismiss_migration_notice()
	if game.menu_overlay.visible or not game.has_started:
		_fail("Continue did not start the saved game")
		return
	game._open_settings()
	if not game.settings_overlay.visible:
		_fail("Settings did not open from gameplay")
		return
	game._request_reset()
	if game.money != 14000 or game.total_earned != 12000 or not game.reset_dialog.visible:
		_fail("Reset changed progress before confirmation")
		return
	game.reset_dialog.hide()
	game._close_settings()
	if game.money != 14000 or game.menu_overlay.visible:
		_fail("Canceling reset changed progress")
		return
	game._open_settings()
	game._reset_progress()
	if game.money != game.Economy.STARTING_CASH or game.total_earned != 0 or game.run_earned != 0 or game.district_index != 0 or game.rebirth_count != 0 or game.vehicle != 0 or game.company or game.workers != 0 or game.deliveries != 0:
		_fail("Confirmed reset left gameplay progress behind")
		return
	if not game.menu_overlay.visible or game.settings_overlay.visible or game.has_started or game.menu_start_button.text != "OYUNA BAŞLA":
		_fail("Reset did not return to a fresh start menu")
		return
	root.remove_child(game)
	game.free()
	var restarted = load("res://scenes/Main.tscn").instantiate()
	root.add_child(restarted)
	if restarted.money != restarted.Economy.STARTING_CASH or restarted.total_earned != 0 or restarted.has_started or restarted.menu_start_button.text != "OYUNA BAŞLA":
		_fail("Reset progress reappeared after restart")
		return
	print("Menu and reset passed: legacy Continue, pause, cancel, confirmed reset, restart")
	quit(0)

func _fail(reason: String) -> void:
	push_error(reason)
	quit(1)
