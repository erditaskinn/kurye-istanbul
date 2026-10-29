extends SceneTree
func _initialize() -> void:
	call_deferred("measure")
func measure() -> void:
	for actions in [["vehicle", "service", "worker"], ["service", "worker", "vehicle"], ["worker", "service", "vehicle"]]:
		for seed_value in [7, 42, 99, 2026, 4242]:
			var game = load("res://scenes/Main.tscn").instantiate()
			root.add_child(game)
			game.set_process(false)
			game._reset_progress()
			game.rng.seed = seed_value
			game._start_playing()
			var first_delivery := -1.0
			var first_district := -1.0
			var unlock := -1.0
			var first_buy := -1.0
			var hire := -1.0
			var action_index := 0
			for step in 1200:
				var seconds := (step + 1) * 0.5
				game._advance_simulation(0.5)
				if first_district < 0 and game.unlocked_district_index > 0: first_district = seconds
				if first_delivery < 0 and game.deliveries > 0: first_delivery = seconds
				if unlock < 0 and game.company: unlock = seconds
				if action_index >= actions.size(): continue
				var action: String = actions[action_index]
				var choice: Dictionary = game._investment(action, 0)
				if game.money < int(choice["cost"]) or (action == "worker" and not game.company): continue
				if action == "vehicle": game._buy_vehicle()
				elif action == "service": game._buy_service()
				else:
					game._hire_worker(0)
					hire = seconds
				if first_buy < 0: first_buy = seconds
				action_index += 1
			print("A4_MEASURE,%s,%d,%.1f,%.1f,%.1f,%.1f,%d" % [actions[0], seed_value, first_delivery, first_buy, unlock, hire, game.total_earned])
			print("A6_FIRST_OPEN,%s,%d,%.1f" % [actions[0], seed_value, first_district])
			game.free()
	quit()
