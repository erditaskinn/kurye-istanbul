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
	game.company_ui.name_field.text = "Martı Kurye"
	game.company_ui.name_field.text_changed.emit("Martı Kurye")
	game.company_ui._choose_logo(0)
	await screen("company-create")
	game.company_ui._confirm_brand()
	await screen("company-map")
	game.money = 10000
	game._refresh_ui()
	game.company_ui.open_tab(2)
	await screen("company-fleet")
	game.company_ui.open_tab(0)
	await screen("company-upgrades")
	game.company_ui.open_tab(1)
	await screen("company-motivation")
	game.company_ui.close_all()
	root.size = Vector2i(480, 1040)
	await screen("company-tall")
	print("Company model previews captured")
	quit()
func screen(name: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/ui-check"))
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/ui-check/%s.png" % name)
