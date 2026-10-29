extends SceneTree

# Capture the real rendered controls without touching the player's save.
# Run with APPDATA pointing to a temporary directory on Windows.
func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	root.size = Vector2i(480, 800)
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/ui-check"))
	var ignore := FileAccess.open("res://build/.gdignore", FileAccess.WRITE)
	if ignore:
		ignore.close()
	await _save("menu")
	game._start_playing()
	await _save("game")
	game._select_map_location(game._location_screen_position(game.pickup_index))
	await _save("location-shop")
	game._close_location_card()
	game._select_map_location(game._location_screen_position(game.PICKUPS.size() + game.drop_index))
	await _save("location-home")
	game._close_location_card()
	game._advance_simulation(20.0)
	game._update_delivery_status()
	await _save("game-carrying")
	game.company = true
	game._refresh_ui()
	game._toggle_company_panel()
	await _save("company")
	game._toggle_company_panel()
	game._toggle_district_panel()
	await _save("district")
	game._toggle_district_panel()
	game._open_settings()
	await _save("settings")
	game._request_reset()
	await _save("reset")
	game.reset_dialog.hide()
	game._close_settings()
	game.district_index = 6
	game.run_earned = game.REBIRTH_THRESHOLD
	game._build_roads()
	game._refresh_ui()
	game._toggle_district_panel()
	game._confirm_rebirth()
	await _save("rebirth")
	game.rebirth_dialog.hide()
	game.district_panel.visible = false
	root.size = Vector2i(480, 1040)
	await _save("game-tall")
	game._back_to_menu()
	await _save("menu-tall")
	root.size = Vector2i(480, 800)
	game._start_playing()
	game._dismiss_return_summary()
	for district in [1, 2, 3, 4, 5, 6]:
		game.district_index = district
		game._build_roads()
		game.player = game._district_spawn()
		game._route_to_mission()
		game._refresh_ui()
		await _save("district-art-%d" % district)
		root.size = Vector2i(480, 1040)
		await _save("district-art-%d-tall" % district)
		root.size = Vector2i(480, 800)
	root.size = Vector2i(480, 800)
	game._start_playing()
	game.company = true
	game.workers = 1
	game.staff_counts.assign([1, 0, 0, 0])
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 600
	game._apply_offline_income()
	game._show_return_summary()
	await _save("offline-summary")
	game._dismiss_return_summary()
	game.last_saved_at = int(Time.get_unix_time_from_system()) - 20000
	game._apply_offline_income()
	game._show_return_summary()
	await _save("offline-summary-capped")
	quit()

func _save(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/ui-check/%s.png" % name)
