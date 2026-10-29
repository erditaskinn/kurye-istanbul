extends "res://tools/capture_company.gd"
func capture() -> void:
	AudioServer.set_bus_mute(0, true)
	var g = load("res://scenes/Main.tscn").instantiate()
	root.add_child(g); g.set_process(false); g.feedback.set_process(false)
	g._reset_progress(); g._create_company("Martı Kurye", 0)
	g.unlocked_district_index = 6; g.run_earned = g.run_prestige_target
	for height in [800, 1040]:
		root.size = Vector2i(480, height)
		g._confirm_rebirth(); g.specialization_choice.select(1); g._refresh_prestige_preview()
		await screen("r7-prestige-" + str(height))
		g.rebirth_dialog.hide()
	quit()
