extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	root.size = Vector2i(480, 800)
	root.gui_embed_subwindows = true
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._reset_progress()
	game._start_playing()
	game.money = 1000000000000
	game.total_earned = 45678901234
	game.deliveries = 1234567
	game.service_level = 20
	game.company = true
	game.staff_counts.assign([2, 1, 0, 0])
	game.workers = 3
	game.message_clock = 0
	game._refresh_ui()
	await screen("polish-map")
	game._toggle_company_panel()
	await screen("polish-crew")
	game._toggle_company_panel()
	game.return_summary = {"seconds": 14400, "solo": 750000, "team": 500000, "completed": 12500, "capped": 1}
	game._show_return_summary()
	await screen("polish-return")
	game._dismiss_return_summary()
	root.size = Vector2i(480, 1040)
	await screen("polish-tall")
	print("Visual polish previews captured")
	quit()
func screen(name: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/ui-check"))
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/ui-check/%s.png" % name)
