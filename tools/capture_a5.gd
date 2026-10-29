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
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 120
	game._apply_offline_income()
	game._show_return_summary()
	await screen("a5-early")
	game._dismiss_return_summary()
	game.company = true
	game.staff_counts.assign([1, 0, 0, 0])
	game.workers = 1
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 120
	game._apply_offline_income()
	game._show_return_summary()
	await screen("a5-demand-limited")
	game._dismiss_return_summary()
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 20000
	game._apply_offline_income()
	game._show_return_summary()
	await screen("a5-capped")
	root.size = Vector2i(480, 1040)
	await screen("a5-tall")
	print("A5 previews captured")
	quit()
func screen(name: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/ui-check"))
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/ui-check/%s.png" % name)
