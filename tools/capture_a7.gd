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
	game._toggle_district_panel()
	game._confirm_rebirth()
	await screen("a7-locked")
	game.rebirth_dialog.hide()
	game.run_earned = game.REBIRTH_THRESHOLD
	game.total_earned = game.REBIRTH_THRESHOLD
	game._update_district()
	for i in 7: game._activate_district(i)
	game._confirm_rebirth()
	await screen("a7-ready")
	game._rebirth()
	game.message_clock = 0
	game._refresh_ui()
	await screen("a7-new-run")
	game.run_earned = game.REBIRTH_THRESHOLD
	game._update_district()
	game._activate_district(6)
	root.size = Vector2i(480, 1040)
	game._confirm_rebirth()
	await screen("a7-second-tour-tall")
	print("A7 previews captured")
	quit()
func screen(name: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/ui-check"))
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/ui-check/%s.png" % name)
