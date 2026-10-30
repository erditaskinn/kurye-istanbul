extends SceneTree
var failures: Array[String] = []
func _initialize() -> void: call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok: failures.append(why); push_error(why)
func run() -> void:
	var g = load("res://scenes/Main.tscn").instantiate()
	root.add_child(g); g.set_process(false); g.feedback.set_process(false)
	g._reset_progress(); g.rng.seed = 4242; g._create_company("Yıldız Kurye", 0)
	g.money = 1000000
	var cash: int = g.money
	g._buy_motivation()
	check(g.motivation_level == 0 and g.money == cash, "Cash bought motivation without stars")
	g.star_progress = 99
	g._advance_simulation(120)
	check(g.motivation_stars >= 1 and g.star_progress < 100, "Delivery milestone missing")
	g.motivation_stars = 30
	var accepted: Dictionary = g.dispatch.active[0].duplicate(true)
	var quote: Dictionary = g._order_quote(1,2)
	var store = g.save_store
	g.save_store = load("res://tests/failing_save_store.gd").new()
	g._buy_motivation()
	check(g.motivation_stars == 30 and g.motivation_level == 0, "Failed save consumed stars")
	g.save_store = store; cash = g.money
	g._buy_motivation()
	check(g.motivation_stars == 20 and g.motivation_level == 1 and g.money == cash, "Wrong upgrade currency")
	check(g.dispatch.active[0] == accepted, "Accepted job repriced")
	check(int(g._order_quote(1,2)["paid"]) == int(round(float(quote["payout"]) * g.Economy.service_multiplier(g.service_level) * g._income_multiplier())), "Actual payout differs from multiplier")
	check(g._order_quote(1,2)["paid"] > quote["paid"], "Permanent bonus ineffective")
	g.unlocked_district_index = 6; g.run_earned = g.run_prestige_target
	var stars: int = g.motivation_stars
	g._rebirth()
	check(g.motivation_stars == stars + 10 and g.motivation_level == 1, "Prestige lost level or award")
	g._save_game(); g.last_saved_at = int(Time.get_unix_time_from_system()) + 60; g._save_game()
	var copy = load("res://scenes/Main.tscn").instantiate(); root.add_child(copy); copy.set_process(false)
	check(copy.motivation_stars == g.motivation_stars and copy.motivation_level == 1 and copy.star_progress == g.star_progress, "Restart lost motivation")
	copy.free()
	g.motivation_level = 20; stars = g.motivation_stars; g._buy_motivation()
	check(g.motivation_level == 20 and g.motivation_stars == stars, "Cap consumed stars")
	g._reset_progress(); check(g.motivation_level == 0 and g.motivation_stars == 0, "Full reset retained motivation")
	g.free()
	if failures.is_empty(): print("Motivation passed: milestone, star-only purchase, failed commit, locked jobs, multiplier, prestige, restart and cap/reset")
	quit(0 if failures.is_empty() else 1)
