extends SceneTree
func _initialize() -> void:
	call_deferred("measure")
func measure() -> void:
	for seed_value in [7, 42, 99, 2026, 4242]:
		for reputation in [0, 1]:
			var game = load("res://scenes/Main.tscn").instantiate()
			root.add_child(game)
			game.set_process(false)
			game._reset_progress()
			game._start_playing()
			game.rng.seed = seed_value
			if reputation == 1:
				game.run_earned = game.REBIRTH_THRESHOLD
				game._update_district()
				game._activate_district(6)
				game._rebirth()
			var actions := ["service", "worker", "vehicle"]
			var action_index := 0
			var first_buy := -1.0
			var hire := -1.0
			for step in 1200:
				game._advance_simulation(0.5)
				if action_index >= actions.size(): continue
				var action: String = actions[action_index]
				var choice: Dictionary = game._investment(action, 0)
				if game.money < int(choice["cost"]) or (action == "worker" and not game.company): continue
				var seconds := (step + 1) * 0.5
				if first_buy < 0: first_buy = seconds
				if action == "service": game._buy_service()
				elif action == "vehicle": game._buy_vehicle()
				else:
					game._hire_worker(0)
					hire = seconds
				action_index += 1
			print("A7_PAIRED,%d,%d,%.1f,%.1f,%d,%d" % [seed_value, reputation, first_buy, hire, game.total_earned, game.money])
			game.free()
	quit()
