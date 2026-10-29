extends SceneTree

func _initialize() -> void:
	call_deferred("run_check")

func run_check() -> void:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._start_playing()
	game.money = 0
	game._refresh_ui()
	if not game.upgrade_details_label.text.contains("100 ₺ kaldı") or not game.upgrade_button.disabled or not game.service_button.disabled:
		_fail("Upgrade cards must show the real target and affordability")
		return
	game.money = 100
	game._refresh_ui()
	if game.upgrade_button.disabled or game.service_button.disabled or not game.upgrade_details_label.text.contains("Satın almaya hazır"):
		_fail("Both starting investment choices must be available")
		return
	var locked_payout: int = game.order_payout
	game._buy_vehicle()
	if game.vehicle != 1 or game.order_payout != locked_payout or not game.upgrade_details_label.text.contains("24,0→15,0"):
		_fail("Vehicle purchase must preserve the accepted quote and show next cycle change")
		return
	game.deliveries = 5
	game._maybe_unlock_team()
	game.money = 150
	game._hire_worker(0)
	game._refresh_ui()
	if not game.staff_labels[0].text.contains("240 ₺ kaldı") or not game.team_map_label.text.contains("Talep sınırlı") or not game.staff_buttons[0].tooltip_text.contains("sürekli geliri artırmaz"):
		_fail("Team cards must identify idle-capacity purchases and escalating costs")
		return
	print("Progression UI passed: two choices, affordability, locked quote, cycle preview and honest capacity advice")
	quit(0)

func _fail(reason: String) -> void:
	push_error(reason)
	quit(1)
