extends "res://tools/capture_company.gd"
func capture() -> void:
	root.size=Vector2i(480,800)
	var game=load("res://scenes/Main.tscn").instantiate();root.add_child(game);game.set_process(false)
	game._reset_progress();game.rng.seed=4242;game._create_company("Martı Kurye",0)
	game.money=10000;game._refresh_ui()
	game.company_ui.open_tab(0);await screen("r4-early-upgrades")
	game.company_ui.open_tab(1);await screen("r4-comfort")
	game._hire_worker(2);game._hire_worker(1)
	game.unlocked_district_index=6;game._activate_district(6)
	game.company_ui.open_tab(2)
	await process_frame
	await process_frame
	game.company_ui.sheet_scroll.scroll_vertical=716;await screen("r4-car")
	game.company_ui.sheet_scroll.scroll_vertical=904;await screen("r4-operations")
	game.company_ui.close_all()
	game._activate_district(4);game.run_earned=game.run_prestige_target
	game._confirm_rebirth();await screen("r4-prestige")
	game.rebirth_dialog.hide()
	root.size=Vector2i(480,1040)
	game.company_ui.open_tab(1);await screen("r4-tall")
	print("R4 specialist/unlock/prestige previews captured in isolated profile")
	quit()
