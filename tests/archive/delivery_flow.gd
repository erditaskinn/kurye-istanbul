extends SceneTree

func _initialize() -> void:
	call_deferred("run_check")

func run_check() -> void:
	# A save from the first APK must resume its existing pickup or delivery.
	var old_save := {"money": 320, "total_earned": 1860, "deliveries": 20, "vehicle": 1, "company": false, "workers": 0, "route_index": 2, "carrying": true, "last_saved_at": int(Time.get_unix_time_from_system())}
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	if file == null:
		_fail("Could not create old-save fixture")
		return
	file.store_string(JSON.stringify(old_save))
	file.close()
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	if game.money != 320 or game.pickup_index != 2 or game.drop_index != 2 or not game.carrying:
		_fail("Old save did not retain the active delivery")
		return
	game._start_playing()
	var payouts := []
	for pickup in game.PICKUPS.size():
		for drop in game.DROPS.size():
			payouts.append(game._calculate_payout(pickup, drop))
	if payouts.max() <= payouts.min():
		_fail("Different road distances did not change delivery pay")
		return
	for i in game.PICKUPS.size() + game.DROPS.size():
		var point: Vector2 = game._pickup_position(i) if i < game.PICKUPS.size() else game._drop_position(i - game.PICKUPS.size())
		if game.roads.closest_location(point)["point"].distance_to(point) > 0.01:
			_fail("A delivery address is not on a road")
			return
	for pickup in game.PICKUPS.size():
		for drop in game.DROPS.size():
			if game.roads.route_between(game._pickup_position(pickup), game._drop_position(drop)).is_empty():
				_fail("Şile has an unreachable delivery pair")
				return
	game.rng.seed = 42
	var orders := {}
	for _step in 6000:
		orders["%d:%d" % [game.pickup_index, game.drop_index]] = true
		game._process(0.1)
	if game.deliveries <= 20 or orders.size() < 5 or game.money <= 320:
		_fail("Automatic deliveries did not vary and earn money")
		return
	game._save_game()
	var saved_orders := [game.pickup_index, game.drop_index, game.order_payout]
	var saved_money: int = game.money
	root.remove_child(game)
	game.free()
	var resumed = load("res://scenes/Main.tscn").instantiate()
	root.add_child(resumed)
	if resumed.money != saved_money or [resumed.pickup_index, resumed.drop_index, resumed.order_payout] != saved_orders:
		_fail("Current delivery was not restored")
		return
	print("Delivery flow passed: old save, varied orders, common order clock, distance pay, resume")
	quit(0)

func _fail(reason: String) -> void:
	push_error(reason)
	quit(1)
