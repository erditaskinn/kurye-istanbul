extends SceneTree
# Reproducible policy samples, not simulated human retention or optimal play.
var results: Array[Dictionary] = []
var failures: Array[String] = []
func _initialize() -> void:
	call_deferred("measure")
func options(game: Control, style: String) -> Array[Dictionary]:
	var candidates: Array[Dictionary] = []
	for kind in ["vehicle", "service", "worker"]:
		if kind == "vehicle" and game.vehicle >= 3: continue
		if kind == "service" and game.service_level >= game.Economy.MAX_SERVICE_LEVEL: continue
		if kind == "worker" and not game.company: continue
		for role in (4 if kind == "worker" else 1):
			var item: Dictionary = game._investment(kind, role)
			if float(item["gain"]) <= 0.001: continue
			item["kind"] = kind
			item["role"] = role
			var preference := 1.0
			if style == "service" and kind == "service": preference = 1.8
			if style == "capacity" and kind != "service": preference = 1.8
			item["score"] = float(item["payback"]) / preference
			candidates.append(item)
	candidates.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return float(a["score"]) < float(b["score"]))
	return candidates
func decision(game: Control, style: String, limit: int) -> int:
	var selected: int = game.district_index
	var best: float = game._production_snapshot()["income"]
	for index in range(game.unlocked_district_index + 1):
		var income: float = game._production_snapshot(-1, -1, -1, index)["income"]
		if income > best + 0.001:
			best = income
			selected = index
	game._activate_district(selected)
	var count := 0
	for purchase in limit:
		var candidates := options(game, style)
		if candidates.is_empty(): break
		# Save for the preferred positive option instead of buying every cheap item.
		var chosen := candidates[0]
		if game.money < int(chosen["cost"]): break
		match str(chosen["kind"]):
			"vehicle": game._buy_vehicle()
			"service": game._buy_service()
			"worker": game._hire_worker(int(chosen["role"]))
		count += 1
	return count
func sample(style: String, interval: int, seed_value: int, warmup: int = 0, profile_version: int = 5) -> Dictionary:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game._reset_progress()
	game.simulation_economy_version = profile_version
	game._start_playing()
	game.rng.seed = seed_value
	var elapsed := 0
	var accounted := 0
	var sessions := 0
	var purchases := 0
	var first_buy := -1
	var first_team := -1
	var first_district := -1
	var first_prestige := -1
	var second_prestige := -1
	var first_accounted := -1
	var first_tour: Dictionary = {}
	var by_hour: Array[Dictionary] = []
	while elapsed < 96 * 3600 and second_prestige < 0:
		var gap := 30 if elapsed < warmup else interval
		var seconds := mini(gap, game.OFFLINE_LIMIT_SECONDS)
		game._advance_simulation(seconds)
		elapsed += gap
		accounted += seconds
		sessions += 1
		if first_district < 0 and game.unlocked_district_index > 0: first_district = elapsed
		var acquired := decision(game, style, 1 if gap == 30 else 3)
		purchases += acquired
		if first_buy < 0 and acquired > 0: first_buy = elapsed
		if first_team < 0 and game.workers > 0: first_team = elapsed
		if game.unlocked_district_index == 6 and game.run_earned >= game.REBIRTH_THRESHOLD:
			game._activate_district(6)
			if not game._rebirth_ready(): failures.append("Final gate mismatch")
			if first_prestige < 0:
				first_prestige = elapsed
				first_accounted = accounted
				first_tour = {"cash": game.money, "revenue": game.run_earned, "service": game.service_level, "staff": game.staff_counts.duplicate(), "vehicle": game.vehicle, "purchases": purchases, "missed": game.dispatch.missed}
				game._rebirth()
			else:
				second_prestige = elapsed
		if by_hour.is_empty() or elapsed / 3600 > int(by_hour[-1]["wall_seconds"]) / 3600:
			by_hour.append({"wall_seconds": elapsed, "accounted_seconds": accounted, "reputation": game.rebirth_count, "run_revenue": game.run_earned, "cash": game.money, "district": game.district_index, "opened": game.unlocked_district_index, "service": game.service_level, "staff": game.workers, "purchases": purchases, "income_estimate": game._production_snapshot()["income"]})
	var result := {"style": style, "warmup_seconds": warmup, "interval_seconds": interval, "seed": seed_value, "first_purchase_seconds": first_buy, "first_staff_seconds": first_team, "first_district_observed_seconds": first_district, "first_prestige_wall_seconds": first_prestige, "first_prestige_accounted_seconds": first_accounted, "second_tour_wall_seconds": second_prestige - first_prestige if second_prestige >= 0 else -1, "decision_windows": sessions, "purchases": purchases, "first_tour": first_tour, "samples": by_hour}
	print("A8,%s,%d,%d,first=%.2fh,accounted=%.2fh,second=%.2fh,buys=%d" % [style, interval, seed_value, first_prestige / 3600.0, first_accounted / 3600.0, float(result["second_tour_wall_seconds"]) / 3600.0, purchases])
	game.free()
	return result
func measure() -> void:
	var label := "baseline"
	if not OS.get_cmdline_user_args().is_empty(): label = OS.get_cmdline_user_args()[0].validate_filename()
	for style in ["balanced", "service", "capacity"]:
		for interval in ([14400, 28800] if label == "warm-start" else [30, 14400, 28800]):
			for seed_value in ([4242] if label == "warm-start" else [42, 4242]):
				results.append(sample(style, interval, seed_value, 600 if label == "warm-start" else 0, 4 if label == "baseline" else load("res://scripts/economy.gd").VERSION))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/balance"))
	var file := FileAccess.open("res://build/balance/a8-" + label + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"label": label, "economy_version": 4 if label == "baseline" else load("res://scripts/economy.gd").VERSION, "max_wall_hours": 96, "per_absence_cap_hours": 4, "results": results, "failures": failures}, "  "))
	file.close()
	print("A8 samples archived: ", results.size(), " failures: ", failures.size())
	quit(0 if failures.is_empty() else 1)
