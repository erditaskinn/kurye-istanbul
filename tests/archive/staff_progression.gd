extends SceneTree

func _initialize() -> void:
	call_deferred("run_check")

func run_check() -> void:
	var dispatch_model = load("res://scripts/dispatch.gd").new()
	var no_staff: Array[int] = [0, 0, 0, 0]
	var make_order := func() -> Dictionary: return {"pickup": 0, "drop": 1, "distance": 300.0, "payout": 42}
	dispatch_model.advance(60.0, no_staff, 0, make_order)
	if dispatch_model.pending.size() != 3:
		_fail("Quiet district demand is wrong")
		return
	dispatch_model.reset()
	dispatch_model.advance(60.0, no_staff, 6, make_order)
	if dispatch_model.pending.size() != 28:
		_fail("Busy district did not generate more orders")
		return
	dispatch_model.advance(180.0, no_staff, 6, make_order)
	if dispatch_model.pending.size() != dispatch_model.MAX_QUEUE or dispatch_model.missed <= 0:
		_fail("Full queue did not count missed orders")
		return
	var old_save := {"money": 10000, "total_earned": 12000, "deliveries": 80, "vehicle": 0, "company": true, "workers": 2, "route_index": 0, "carrying": false, "last_saved_at": int(Time.get_unix_time_from_system())}
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	if file == null:
		_fail("Could not create old company save")
		return
	file.store_string(JSON.stringify(old_save))
	file.close()
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	if game.staff_counts != [2, 0, 0, 0]:
		_fail("Existing workers were not migrated to walking couriers")
		return
	game._start_playing()
	game._toggle_company_panel()
	if not game.company_panel.visible:
		_fail("Company management panel did not open")
		return
	game._hire_worker(3)
	if game.money != 16600 or game.staff_counts != [2, 0, 0, 1]:
		_fail("Car courier cost or staff count is wrong")
		return
	if game._staff_cost(3) != 3840 or game.dispatch.delivery_seconds(3, game.district_index, 300.0) >= game.dispatch.delivery_seconds(0, game.district_index, 300.0):
		_fail("Repeated hire cost or vehicle speed is wrong")
		return
	game._advance_dispatch(60.0)
	if game.dispatch.active.is_empty():
		_fail("Staff did not start a visible order")
		return
	var first_job: Dictionary = game.dispatch.active[0].duplicate()
	if not first_job.has("paid") or not first_job.has("district"):
		_fail("Accepted jobs did not lock their payout and source district")
		return
	game._save_game()
	root.remove_child(game)
	game.free()
	game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	if game.dispatch.active.is_empty() or int(game.dispatch.active[0]["slot"]) != int(first_job["slot"]) or int(game.dispatch.active[0]["pickup"]) != int(first_job["pickup"]):
		_fail("Visible staff trip did not survive restart")
		return
	game._start_playing()
	for _step in 600:
		game._process(1.0)
		if game.dispatch.pending.size() > game.dispatch.MAX_QUEUE or game.dispatch.team_active_count() > game.workers:
			_fail("Company queue or active jobs exceeded capacity")
			return
	if game.dispatch.completed < 5 or game.money <= 16600:
		_fail("Staff did not complete paid orders")
		return
	var completed_before: int = game.dispatch.completed
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 600
	var offline_income: int = game._apply_offline_income()
	if game.dispatch.completed <= completed_before or offline_income <= 0:
		_fail("Company orders did not continue offline")
		return
	game._save_game()
	var saved_money: int = game.money
	var saved_completed: int = game.dispatch.completed
	root.remove_child(game)
	game.free()
	var resumed = load("res://scenes/Main.tscn").instantiate()
	root.add_child(resumed)
	if resumed.money != saved_money or resumed.staff_counts != [2, 0, 0, 1] or resumed.workers != 3 or resumed.dispatch.completed != saved_completed:
		_fail("Company staff did not survive restart")
		return
	print("Staff progression passed: old save, car hire, shared queue, locked jobs, real orders, offline dispatch, restart")
	quit(0)

func _fail(reason: String) -> void:
	push_error(reason)
	quit(1)
