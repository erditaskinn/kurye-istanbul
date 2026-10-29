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
	game.rng.seed = 4242
	game._start_playing()
	game.message_clock = 0
	game._refresh_ui()
	expect(game._guide_step() == 0 and not game.guide_seen and not game.guide_panel.visible, "Fresh player must have optional first lesson")
	game._toggle_guide()
	expect(game.guide_seen and game.guide_panel.visible, "Guide must open and persist acknowledgement")
	var cash: int = game.money
	game._advance_simulation(100)
	game._refresh_ui()
	expect(game.money > cash and game._guide_step() == 1, "Guide must not pause automatic production or force a purchase")
	expect(game.guide_title.text.begins_with("2") and "100" in game.guide_body.text, "Guide must follow actual investment state")
	game._buy_service()
	expect(game._guide_step() == 2, "Service-first must be accepted as the first investment")
	var unlock := 0.0
	for step in 1200:
		game._advance_simulation(0.5)
		if game.company:
			unlock = 100 + (step + 1) * 0.5
			break
	game._refresh_ui()
	expect(game._guide_step() == 3 and unlock > 0, "Five deliveries must lead to optional staff lesson")
	while game.money < 150:
		game._advance_simulation(0.5)
	game._hire_worker(0)
	game._refresh_ui()
	expect(game._guide_step() == 4 and "Talep" in game.guide_body.text, "Staff milestone must explain demand constraint")
	expect("Beykoz" in game.guide_goal.text and str(game.DISTRICT_THRESHOLDS[1]) in game.guide_goal.text, "Near and long goals must use actual district threshold")
	expect(not game._map_input_allowed(Vector2(50, 200)), "Guide must consume touches inside its card")
	var income: int = game.total_earned
	game._toggle_guide()
	game._toggle_guide()
	expect(game.total_earned == income, "Reopening guide must not create reward")
	game._toggle_company_panel()
	expect(not game.guide_panel.visible and game.company_panel.visible, "Guide and team panel must not overlap")
	game._save_game()
	game.free()
	var restored = load("res://scenes/Main.tscn").instantiate()
	root.add_child(restored)
	restored.set_process(false)
	expect(restored.guide_seen and restored._guide_step() == 4 and not restored.guide_panel.visible, "Restart must retain acknowledgement and infer progress")
	restored._reset_progress()
	expect(not restored.guide_seen and restored._guide_step() == 0, "Explicit reset must restore first lesson")
	restored.free()
	print("A4 service-first first-team-unlock seconds: ", unlock)
	if failures.is_empty(): print("Onboarding passed: optional state lessons, ongoing production, goals, panel input and save/reset")
	quit(0 if failures.is_empty() else 1)
