extends "res://tools/capture_company.gd"
func capture() -> void:
	AudioServer.set_bus_mute(0, true)
	var g = load("res://scenes/Main.tscn").instantiate()
	root.add_child(g); g.set_process(false); g.feedback.set_process(false)
	g._reset_progress(); g._create_company("Martı Kurye", 0)
	g.motivation_stars = 15
	for height in [800,1040]:
		root.size = Vector2i(480,height)
		g.company_ui.close_all(); await screen("fleet-nav-" + str(height))
		g.company_ui.open_tab(4); await screen("fleet-sheet-" + str(height))
		g.company_ui.open_tab(1); await screen("motivation-stars-" + str(height))
	g.free(); quit()
