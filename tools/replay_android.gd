extends SceneTree
func _initialize() -> void:
	call_deferred("replay")
func replay() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 3:
		push_error("Expected source JSON path, absence seconds, result path")
		quit(1)
		return
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(args[0]))
	data["last_saved_at"] = int(Time.get_unix_time_from_system()) + 60
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	var before: int = game.money
	game._advance_simulation(float(args[1]))
	var output := {"income": game.money - before, "money_after": game.money, "dispatch": game.dispatch.to_save(), "rng_state": str(game.rng.state)}
	file = FileAccess.open(args[2], FileAccess.WRITE)
	file.store_string(JSON.stringify(output, "  "))
	file.close()
	print("Independent replay income: ", output["income"])
	quit()
