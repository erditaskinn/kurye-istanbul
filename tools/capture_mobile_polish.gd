extends "res://tools/capture_company.gd"
func capture() -> void:
	AudioServer.set_bus_mute(0,true)
	root.size=Vector2i(480,800)
	var g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false);g.feedback.set_process(false)
	g._reset_progress();g._create_company("Martı Kurye",0)
	g.unlocked_district_index=1;g.company_ui._process(0)
	await screen("mobile-first-district")
	g.company_ui._first_district(false)
	g._safe_layout(Rect2(24,48,432,720));await process_frame
	g.company_ui.open_tab(4);await screen("mobile-safe-fleet")
	root.size=Vector2i(480,1040);g._safe_layout(Rect2(0,32,480,984));await process_frame
	g.company_ui.open_tab(1);await screen("mobile-safe-motivation-tall")
	g.free();quit()
