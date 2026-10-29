extends SceneTree
var failures: Array[String] = []
func _initialize() -> void: call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok: failures.append(why); push_error(why)
func fresh():
	var g = load("res://scenes/Main.tscn").instantiate()
	root.add_child(g); g.set_process(false); g.feedback.set_process(false)
	g._reset_progress(); g.rng.seed = 4242; g._create_company("Uzman Kurye", 0)
	return g
func run() -> void:
	var g = fresh()
	check(g.specialization_id == "standard", "First run has specialization")
	check(g.Specialization.valid("unknown") == "standard", "Unknown model unsafe")
	for model in 4:
		g.specialization_id = g.Specialization.IDS[model]
		for district in 7:
			g.district_index = district
			var base: Array = g.Economy.company_speeds(district, 0, 0)
			var actual: Array = g._company_speeds()
			for role in 4:
				var factor := 1.0
				if (model == 1 and role < 2) or (model == 2 and role == 2): factor = 1.15
				if model == 3 and role == 3: factor = 1.2
				check(is_equal_approx(actual[role], base[role] * factor), "Role effect mismatch")
			var quote: Dictionary = g._order_quote(0, 0)
			check(quote["speed_profile"] == actual, "Quote differs from effective speed")
		g.district_index = 0
		g.specialization_choice.select(model)
		var before: Dictionary = g._save_data().duplicate(true)
		var candidate: Dictionary = g._prepare_rebirth_record()
		check(before == g._save_data(), "Preview mutated state")
		check(candidate["specialization_id"] == g.Specialization.IDS[model], "Candidate lost choice")
		g.unlocked_district_index = 6; g.run_earned = g.run_prestige_target
		var store = g.save_store
		g.save_store = load("res://tests/failing_save_store.gd").new()
		before = g._save_data().duplicate(true)
		g._rebirth()
		check(g._save_data() == before, "Failed transaction changed model")
		g.save_store = store; g._rebirth()
		check(g.specialization_id == candidate["specialization_id"], "Committed model mismatch")
		check(g.dispatch.to_save() == candidate["dispatch"], "First job differs from committed candidate")
		g._save_game()
		var copy = load("res://scenes/Main.tscn").instantiate()
		root.add_child(copy); copy.set_process(false)
		check(copy.specialization_id == g.specialization_id, "Restart lost model")
		copy.free()
		var reference = fresh()
		g._reset_progress(); g.rng.seed = 4242; g._create_company("Uzman Kurye", 0)
		g.specialization_id = g.Specialization.IDS[model]; reference.specialization_id = g.specialization_id
		g._advance_simulation(14400)
		for chunk in 24: reference._advance_simulation(600)
		check(g.money == reference.money and g.rng.state == reference.rng.state and g.dispatch.completed == reference.dispatch.completed, "Partitioned offline mismatch")
		reference.free()
	# Missing model in an old schema remains standard, without granting retrospective bonuses.
	var legacy: Dictionary = g._save_data().duplicate(true)
	legacy.erase("specialization_id"); legacy["save_version"] = 8; legacy["rebirth_count"] = 3
	legacy["last_saved_at"] = int(Time.get_unix_time_from_system())
	var file := FileAccess.open(g.SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(legacy)); file.close()
	g._load_game()
	check(g.specialization_id == "standard", "Legacy save gained model")
	g._reset_progress(); check(g.specialization_id == "standard", "Reset retained model")
	g.free()
	if failures.is_empty(): print("Specialization passed: role/district matrix, quote, atomic prestige, restart, old schema, reset and partitioned4h simulation")
	quit(0 if failures.is_empty() else 1)
