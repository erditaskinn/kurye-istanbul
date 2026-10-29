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
	await screen("a3-start")
	for step in 1200:
		game._advance_simulation(0.5)
		if game.money >= 100:
			break
	game._refresh_ui()
	await screen("a3-choice")
	game._buy_service()
	game.message_clock = 0.0
	game._refresh_ui()
	await screen("a3-service")
	for step in 1200:
		game._advance_simulation(0.5)
		if game.company and game.money >= 150:
			break
	game._hire_worker(0)
	game.message_clock = 0.0
	game._refresh_ui()
	await screen("a3-demand-limited")
	game._toggle_company_panel()
	await screen("a3-team")
	game._toggle_company_panel()
	root.size = Vector2i(480, 1040)
	await screen("a3-tall")
	print("A3 UI previews captured")
	quit()

func screen(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/ui-check/%s.png" % name)
