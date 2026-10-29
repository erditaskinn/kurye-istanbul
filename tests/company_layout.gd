extends SceneTree
var failures: Array[String] = []
func _initialize() -> void:
	call_deferred("check")
func expect(ok: bool, reason: String) -> void:
	if not ok:
		failures.append(reason)
		push_error(reason)
func check() -> void:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game); game.set_process(false)
	game._reset_progress(); game._create_company("İstanbul Dağıtım", 5)
	for height in [800,1040]:
		root.size = Vector2i(480,height)
		await process_frame
		game.money = 1000000000000
		game.total_earned = 987654321012345
		game.deliveries = 1234567890
		game._refresh_ui()
		for counter in [game.money_label, game.revenue_label, game.deliveries_label]:
			var font: Font = counter.get_theme_font("font")
			expect(font.get_string_size(counter.text, HORIZONTAL_ALIGNMENT_LEFT, -1, counter.get_theme_font_size("font_size")).x <= counter.size.x, "Large HUD value must fit its counter")
		for button in game.company_ui.nav:
			expect(Rect2(Vector2.ZERO,game.size).encloses(button.get_rect()), "Bottom navigation must stay inside viewport")
			expect(button.text.is_empty() and button.icon != null, "Navigation must use approved icons without visible text")
			expect(button.size.x >= 44 and button.size.y >= 44, "Navigation touch targets must be at least 44px")
		for tab in 3:
			game.company_ui.open_tab(tab)
			expect(game.company_ui.nav[tab].icon == game.company_ui.nav_pressed[tab], "Open tab must show its approved pressed artwork")
			game.company_ui.close_all()
			expect(game.company_ui.nav[tab].icon == game.company_ui.nav_normal[tab], "Closed tab must restore normal artwork")
		for district in 7:
			game.district_index = district
			var boxes: Array[Rect2] = []
			for index in 16:
				var center: Vector2 = game._location_screen_position(index)
				var rect := Rect2(center - Vector2(22,22), Vector2(44,44))
				expect(game._map_rect().encloses(rect), "Map touch area escaped enlarged map")
				for other in boxes: expect(not rect.intersects(other), "Enlarged company map introduced overlapping markers")
				boxes.append(rect)
		game.company_ui.open_tab(2)
		for panel in game.company_ui.content.get_children():
			if panel is Panel:
				for child in panel.get_children():
					if child is TextureRect: expect(child.size.x <= 54 and child.size.y <= 66, "Fleet portrait must not expand to atlas dimensions")
		game._handle_android_back()
	game.free()
	if failures.is_empty(): print("Company layout passed: four tabs, seven maps, two phone ratios, 44px touch targets and bounded fleet portraits")
	quit(0 if failures.is_empty() else 1)
