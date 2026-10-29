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
	game.return_summary = {"seconds": 600, "solo": 140, "team": 0, "completed": 0, "capped": 0}
	game._show_return_summary()
	expect(game.return_choices.size() == 3, "Fresh return must offer two investments and district information")
	var kinds: Array[String] = []
	for choice in game.return_choices: kinds.append(choice["kind"])
	expect("vehicle" in kinds and "service" in kinds and not "worker" in kinds, "Locked staff must not be recommended")
	expect("kaldı" in game.return_choice_buttons[0].text and "Kasa 60" in game.return_goal_label.text, "Unaffordable choices need real shortfall and current balance")
	game.money = 100
	game._refresh_ui()
	expect("hazır" in game.return_choice_buttons[0].text, "Advice must follow ongoing balance changes")
	var cash: int = game.money
	game._open_return_choice(kinds.find("service"))
	expect(not game.return_overlay.visible and game.money == cash and game.service_level == 0 and game.return_summary.is_empty(), "Investment navigation must acknowledge summary without buying or paying")
	game.unlocked_district_index = 1
	game.return_summary = {"seconds": 600, "solo": 100, "team": 0, "completed": 0, "capped": 0}
	game._show_return_summary()
	expect(game.return_choices[0]["kind"] == "district" and "açık" in game.return_goal_label.text, "Unlocked district must be visible on return without automatically activating it")
	game._open_return_choice(0)
	expect(game.district_panel.visible and game.district_index == 0, "Compare option must open district screen without changing district")
	game.district_panel.hide()
	game.unlocked_district_index = 0
	game.company = true
	game.workers = 1
	game.staff_counts.assign([1, 0, 0, 0])
	game.money = 200
	game.return_summary = {"seconds": 14400, "solo": 500, "team": 300, "completed": 12, "capped": 1}
	game._show_return_summary()
	expect(game.return_total_label.text == "+800 ₺" and "12" in game.return_breakdown_label.text and "4 saat" in game.return_time_label.text, "Credited breakdown must remain distinct from recommendations")
	expect(game.return_choices[0]["kind"] == "service", "Demand-limited company must prioritize service")
	for choice in game.return_choices:
		if choice.has("gain"): expect(float(choice["gain"]) > 0, "Zero contribution capacity must not be recommended")
	expect("Talep sınırlı" in game.return_goal_label.text, "Current bottleneck must be explicit")
	game.district_index = game.DISTRICTS.size() - 1
	game.unlocked_district_index = game.district_index
	game._refresh_ui()
	expect(game.Numbers.compact(game.REBIRTH_THRESHOLD) in game.return_goal_label.text, "Final district must show actual new-tour target")
	game.district_index = 0
	game.unlocked_district_index = 0
	game.service_level = game.Economy.MAX_SERVICE_LEVEL
	game.vehicle = 3
	game._refresh_ui()
	for choice in game.return_choices: expect(not choice.has("cost"), "Maxed demand-limited game must use informational options instead of fake investments")
	var guide_index := -1
	for i in game.return_choices.size():
		if game.return_choices[i]["kind"] == "guide": guide_index = i
	game._open_return_choice(guide_index)
	expect(game.guide_panel.visible and not game.return_overlay.visible, "Information option must open guide without overlapping summary")
	game.guide_panel.hide()
	game._reset_progress()
	game._start_playing()
	game.company = true
	game.money = 1000
	var options: Array[Dictionary] = game._return_investments()
	var worker_found := false
	for option in options:
		if option["kind"] == "worker": worker_found = true
	expect(worker_found, "Capacity-limited unlocked company must offer positive staff investment")
	game.return_summary = {"seconds": 600, "solo": 100, "team": 0, "completed": 0, "capped": 0}
	game._show_return_summary()
	for i in game.return_choices.size():
		if game.return_choices[i]["kind"] == "worker":
			game._open_return_choice(i)
			break
	expect(game.company_panel.visible and game.workers == 0, "Worker choice must open hiring screen without hiring")
	game.free()
	if failures.is_empty(): print("Return choices passed: affordability, positive marginal advice, fallback goals, live balance and navigation without purchases")
	quit(0 if failures.is_empty() else 1)
