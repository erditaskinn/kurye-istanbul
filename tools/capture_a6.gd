extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	root.size = Vector2i(480, 800)
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._reset_progress()
	game._start_playing()
	game._credit(500)
	game._toggle_district_panel()
	game._select_district(1)
	await screen("a6-compare")
	game._activate_district(1)
	await screen("a6-activated")
	game._toggle_album()
	await screen("a6-album-partial")
	game._toggle_album()
	game._credit(200000)
	for i in 7: game._activate_district(i)
	game._toggle_album()
	await screen("a6-album-full")
	game.album_scroll.scroll_vertical = 400
	await screen("a6-album-bottom")
	root.size = Vector2i(480, 1040)
	await screen("a6-album-tall")
	game._toggle_district_panel()
	game._activate_district(0)
	game.return_summary = {"seconds": 600, "solo": 200, "team": 100, "completed": 4, "capped": 0}
	game._show_return_summary()
	await screen("a6-return-unlocked")
	print("A6 previews captured")
	quit()
func screen(name: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/ui-check"))
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/ui-check/%s.png" % name)
