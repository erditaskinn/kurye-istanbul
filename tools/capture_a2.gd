extends SceneTree

# Developer preview: run only with an isolated APPDATA/user directory.
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
	if ignore:
		ignore.close()
	game._refresh_ui()
	await save_screen("a2-pickup")
	game._advance_simulation(20.0)
	game._refresh_ui()
	await save_screen("a2-delivering")
	game.company = true
	game.staff_counts.assign([1, 0, 0, 0])
	game.workers = 1
	game.dispatch.pending.append(game._make_company_order())
	game._advance_simulation(0.0)
	game._refresh_ui()
	await save_screen("a2-team")
	game._toggle_company_panel()
	await save_screen("a2-company-working")
	game._toggle_company_panel()
	for second in 600:
		if game.dispatch.founder_job().is_empty():
			break
		game._advance_simulation(1.0)
	game._refresh_ui()
	await save_screen("a2-waiting")
	game._seed_founder_job()
	game.district_index = 1
	game._build_roads()
	game._refresh_ui()
	await save_screen("a2-previous-district")
	game._select_map_location(game._location_screen_position(game.pickup_index))
	await save_screen("a2-previous-district-card")
	print("A2 UI previews captured")
	quit()

func save_screen(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/ui-check/%s.png" % name)
