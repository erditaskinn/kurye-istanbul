extends SceneTree

func _initialize() -> void:
	call_deferred("run_check")

func run_check() -> void:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._start_playing()
	game.dispatch.reset()
	game.pickup_index = 1
	game.drop_index = 2
	game.carrying = false
	game.order_payout = game._calculate_payout(1, 2)
	game._seed_founder_job()
	game._refresh_ui()
	if not game.mission_label.text.contains("PAKET ALIMI") or not game.status_label.text.contains(game.PICKUPS[1]["name"]) or not game.status_label.text.contains(game.DROPS[2]["name"]):
		_fail("Accepted order phase and addresses must be visible")
		return
	game._process(1.2)
	if game.delivery_progress_bar.value <= 0.0:
		_fail("Pickup progress must reflect the common clock")
		return
	var job: Dictionary = game.dispatch.founder_job()
	var locked_remaining: float = job["remaining"]
	var locked_pay: int = job["founder_paid"]
	game.money = 300
	game._buy_vehicle()
	if job["remaining"] != locked_remaining or int(job["founder_paid"]) != locked_pay:
		_fail("Buying a vehicle must preserve the accepted job's time and pay")
		return
	var balance_after_purchase: int = game.money
	game._advance_simulation(float(job["pickup_seconds"]) - (float(job["duration"]) - float(job["remaining"])))
	game._update_delivery_status()
	if not game.carrying or not game.mission_label.text.contains("TESLİMAT") or game.delivery_progress_bar.value > 0.01:
		_fail("Pickup must transition to delivery at the exact event time")
		return
	game._select_map_location(game._location_screen_position(3))
	var before: int = game.deliveries
	game._process(float(job["remaining"]))
	if game.deliveries != before + 1 or game.money != balance_after_purchase + locked_pay or not game.location_panel.visible:
		_fail("Delivery must pay exactly once while the information card is open")
		return
	print("Delivery status passed: common clock phases, addresses, progress, locked upgrade and automatic payment")
	quit(0)

func _fail(reason: String) -> void:
	push_error(reason)
	quit(1)
