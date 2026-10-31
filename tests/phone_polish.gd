extends SceneTree
var failures: Array[String] = []
func _initialize() -> void: call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok: failures.append(why); push_error(why)
func run() -> void:
	root.size = Vector2i(480, 1040)
	var g = load("res://scenes/Main.tscn").instantiate()
	root.add_child(g); g.set_process(false); g.feedback.set_process(false)
	g._reset_progress(); g._create_company("Telefon Testi", 0)
	var ui = g.company_ui
	g.total_earned = 1000; g.lifetime_deliveries = 10
	g.achievement_claimed.assign(["delivery10"])
	ui.open_tab(2)
	ui._request_tab(5)
	check(ui.sheet_tab == 2, "Input callback removed controls before dispatch completed")
	await process_frame
	await process_frame
	check(ui.sheet_tab == 5, "Deferred achievement transition failed")
	check(ui.achievement_rows["revenue1000"]["bar"].get_parent().position.y == 72, "Ready reward must be visible first")
	check(ui.achievement_rows["delivery10"]["bar"].get_parent().position.y > 72, "Claimed row obscures ready reward")
	for row in ui.achievement_rows.values(): check(row["bar"].mouse_filter == Control.MOUSE_FILTER_IGNORE, "Progress bar steals scroll gesture")
	for tab in [4, 0]:
		ui.open_tab(tab)
		await process_frame
		check(ui.comparison_buttons.size() == (4 if tab == 4 else 3), "Investment comparison missing")
		var cash: int = g.money
		ui.comparison_buttons.values()[-1].pressed.emit()
		check(g.money == cash and ui.sheet_scroll.scroll_vertical > 0, "Preview must scroll without purchase")
	g.motivation_stars = 3
	g._buy_motivation()
	check(g.motivation_level == 1 and g.motivation_stars == 0, "First motivation must be accessible with3stars")
	check(g._motivation_cost() == 15 and is_equal_approx(g._motivation_multiplier(), 1.2), "Later cost/bonus changed")
	check(ui._duration(3.63) == "3 dk 38 sn", "Payback time should use minutes and seconds")
	g._refresh_ui()
	for child in ui.fleet_ribbon.get_children():
		if child is TextureRect: check(child.size.x <= 28 and child.size.y <= 30, "Ribbon artwork grew to atlas size")
	check(ui.company_progress.text.contains("Hizmet"), "Persistent company progress missing")
	g.free()
	if failures.is_empty(): print("Phone polish passed: deferred transition, ready rewards first, scroll-through progress, comparison without purchase, introductory motivation and readable durations")
	quit(0 if failures.is_empty() else 1)
