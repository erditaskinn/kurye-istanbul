extends SceneTree
var failures: Array[String] = []
func _initialize() -> void:
	call_deferred("check")
func expect(ok: bool, reason: String) -> void:
	if not ok:
		failures.append(reason)
		push_error(reason)
func check() -> void:
	root.size = Vector2i(480, 800)
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._reset_progress()
	game._start_playing()
	game.money = 1000000000000
	game.total_earned = 45678901234
	game.deliveries = 1234567
	game.service_level = 48
	game._refresh_ui()
	expect(game.money_label.text == "KASA\n1T ₺" and "B" in game.revenue_label.text and "M" in game.deliveries_label.text, "Large balances, turnover and delivery counts must use units")
	expect(game.money_label.tooltip_text == "1.000.000.000.000 ₺" and game.money == 1000000000000, "Exact values must stay available and unchanged")
	for label in [game.money_label, game.revenue_label, game.deliveries_label]:
		var font: Font = label.get_theme_font("font")
		var line: String = label.text.split("\n")[-1]
		expect(font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, label.get_theme_font_size("font_size")).x <= label.size.x, "Compact HUD value overflows")
	var cost: int = game.Economy.service_cost(48)
	expect(game.Numbers.compact(cost) in game.service_button.text, "Late upgrade price must also use units")
	game._buy_service()
	expect(game.money == 1000000000000 - cost and game.service_level == 49, "Display abbreviations must not enter purchase arithmetic")
	game.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	game._save_game()
	var data: Dictionary = game.save_store.load_record(game.SAVE_PATH)
	expect(int(data["money"]) == game.money and int(data["service_level"]) == 49, "Save must retain exact numeric values")
	expect(game.upgrade_button.get_theme_stylebox("normal").get_script() == load("res://scripts/pixel_style.gd"), "Primary buttons must use the pixel skin")
	expect(game.SHOP_PIXELS.size() == 8 and game.HOME_PIXELS.size() == 8, "Each location must have a pixel icon variant")
	game.free()
	if failures.is_empty(): print("Visual polish passed: large-number layout, exact purchase/save, pixel theme and location variants")
	quit(0 if failures.is_empty() else 1)
