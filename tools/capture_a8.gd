extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	root.size = Vector2i(480, 800)
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._start_playing()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/ui-check"))
	var ignore := FileAccess.open("res://build/.gdignore", FileAccess.WRITE)
	if ignore: ignore.close()
	game.message_clock = 0.0
	game._refresh_ui()
	await screen("a8-start")
	game._toggle_guide()
	await screen("a8-intro")
	game._advance_simulation(100)
	game.message_clock = 0
	game._refresh_ui()
	await screen("a8-choice")
	game._buy_service()
	game._advance_simulation(250)
	game._hire_worker(0)
	game.message_clock = 0
	game._refresh_ui()
	await screen("a8-bottleneck")
	root.size = Vector2i(480, 1040)
	await screen("a8-tall")
	print("A8 UI previews captured")
	quit()

func screen(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/ui-check/%s.png" % name)
