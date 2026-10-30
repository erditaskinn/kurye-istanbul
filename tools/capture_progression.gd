extends "res://tools/capture_company.gd"
func capture() -> void:
	AudioServer.set_bus_mute(0, true)
	var g = load("res://scenes/Main.tscn").instantiate()
	root.add_child(g); g.set_process(false); g.feedback.set_process(false)
	g._reset_progress(); g._create_company("Martı Kurye", 0)
	g.motivation_stars = 16; g.motivation_level = 2; g.star_progress = 72; g.lifetime_deliveries = 172
	for height in [800,1040]:
		root.size = Vector2i(480,height)
		g.company_ui.open_tab(1); await screen("progression-motivation-" + str(height))
		g.company_ui.open_tab(5); await screen("progression-achievements-" + str(height))
		g.company_ui.close_all(); g._confirm_rebirth(); g._show_specialization_menu("model")
		await screen("progression-specialization-" + str(height))
		g.model_menu.hide(); g.rebirth_dialog.hide()
		g.last_saved_at = int(Time.get_unix_time_from_system()) - 14400
		g._apply_offline_income(); g._show_return_summary(); await screen("progression-return-" + str(height))
		g._dismiss_return_summary()
	g.free(); quit()
