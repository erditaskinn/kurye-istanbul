extends SceneTree

func _initialize() -> void:
	call_deferred("run_check")

func run_check() -> void:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._start_playing()
	game.company = true
	game.workers = 1
	game.staff_counts.assign([1, 0, 0, 0])
	var balance: int = game.money
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 600
	var income: int = game._apply_offline_income()
	if income <= 0 or game.money - balance != income or int(game.return_summary["solo"]) + int(game.return_summary["team"]) != income or int(game.return_summary["completed"]) <= 0:
		_fail("Summary must match actual credited solo and team income")
		return
	game._show_return_summary()
	var marker: Vector2 = game._location_screen_position(0)
	if not game.return_overlay.visible or game._map_input_allowed(marker):
		_fail("Return summary must block map interactions")
		return
	game._save_game()
	var summary_before: Dictionary = game.return_summary.duplicate()
	game.queue_free()
	await process_frame
	game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._start_playing()
	if not game.return_overlay.visible or game.return_summary != summary_before:
		_fail("An unread summary must survive restarting without duplicate income")
		return
	balance = game.money
	game._dismiss_return_summary()
	game._show_return_summary()
	if game.money != balance or game.return_overlay.visible or not game.return_summary.is_empty():
		_fail("Dismissing the summary must not credit money again")
		return
	game._open_settings()
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 120
	game._close_settings()
	if not game.return_overlay.visible:
		_fail("Returning from a paused screen must show the earned summary")
		return
	game._dismiss_return_summary()
	game.company = false
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 20000
	income = game._apply_offline_income()
	if income != int(game.return_summary["solo"]) + int(game.return_summary["team"]) or int(game.return_summary["seconds"]) != game.OFFLINE_LIMIT_SECONDS or int(game.return_summary["capped"]) != 1:
		_fail("Four-hour cap and summary duration must agree")
		return
	game._show_return_summary()
	var arrival_before: float = game.dispatch.arrival_elapsed
	game._process(0.1)
	if is_equal_approx(game.dispatch.arrival_elapsed, arrival_before):
		_fail("Automatic deliveries must continue behind the summary")
		return
	print("Offline summary passed: actual breakdown, persistence, no duplicate credit, four-hour cap and ongoing automation")
	quit(0)

func _fail(reason: String) -> void:
	push_error(reason)
	quit(1)
