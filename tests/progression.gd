extends SceneTree
var failures: Array[String] = []
func _initialize() -> void: call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok: failures.append(why); push_error(why)
func fresh():
	var g = load("res://scenes/Main.tscn").instantiate()
	root.add_child(g); g.set_process(false); g.feedback.set_process(false)
	g._reset_progress(); g.rng.seed = 4242; g._create_company("Kalıcı Şirket", 0)
	return g
func run() -> void:
	var g = fresh()
	g._claim_achievement("delivery10")
	check(g.motivation_stars == 0, "Locked achievement paid")
	g.lifetime_deliveries = 10
	var store = g.save_store
	g.save_store = load("res://tests/failing_save_store.gd").new()
	g._claim_achievement("delivery10")
	check(g.achievement_claimed.is_empty() and g.motivation_stars == 0, "Failed claim changed balance")
	g.save_store = store; g._claim_achievement("delivery10"); g._claim_achievement("delivery10")
	check(g.motivation_stars == 1 and g.achievement_claimed == ["delivery10"], "Claim duplicated or lost")
	g._claim_achievement("unknown")
	check(g.motivation_stars == 1, "Unknown achievement paid")
	g.last_saved_at = int(Time.get_unix_time_from_system()) + 60; g._save_game()
	var copy = load("res://scenes/Main.tscn").instantiate(); root.add_child(copy); copy.set_process(false)
	check(copy.achievement_claimed == g.achievement_claimed and copy.lifetime_deliveries == 10, "Restart lost milestones")
	copy._claim_achievement("delivery10"); check(copy.motivation_stars == 1, "Restart allowed duplicate")
	copy.free()
	g.unlocked_district_index = 6; g.run_earned = g.run_prestige_target; g._rebirth()
	check(g.lifetime_deliveries == 10 and g.achievement_claimed == ["delivery10"], "Prestige reset achievements")
	g._reset_progress(); g._create_company("Dönüş Şirketi", 0)
	g.star_progress = 99; g.last_saved_at = int(Time.get_unix_time_from_system()) - 3600
	var before: int = g.motivation_stars
	g._apply_offline_income()
	check(int(g.return_summary.get("stars", -1)) == g.motivation_stars - before, "Return star delta wrong")
	check(g.lifetime_deliveries > 0, "Offline deliveries missing from milestones")
	g._show_return_summary()
	check("Yıldız" in g.return_breakdown_label.text, "Return screen missing star progress")
	g._dismiss_return_summary(); g._apply_offline_income()
	check(g.motivation_stars >= before, "Zero absence changed reward incorrectly")
	for height in [800,1040]:
		root.size = Vector2i(480, height); await process_frame
		for tab in [1,5]:
			g.company_ui.open_tab(tab); await process_frame
			if tab == 5:
				check(g.company_ui.achievement_rows.size() == g.Achievements.ITEMS.size(), "Missing achievement cards")
				for row in g.company_ui.achievement_rows.values():
					check(row["button"].size.y >= 44, "Small claim target")
					check(row["detail"].get_line_count() * row["detail"].get_line_height() <= row["detail"].size.y + 1, "Achievement text clipped")
			else:
				check(g.company_ui.motivation_bar.value == g.star_progress, "Motivation progress incorrect")
			g.company_ui.close_all()
		g._confirm_rebirth(); g._show_specialization_menu("model"); await process_frame
		check(g.model_menu.visible and g.model_menu.size.x <= 480 and g.model_menu.size.y <= height, "Specialization picker escaped phone")
		g.model_menu.choose(2)
		check(not g.model_menu.visible and g.specialization_choice.selected == 2, "Card selection failed")
		check(g.rebirth_dialog.visible, "Choosing model closed final confirmation")
		g._show_specialization_menu("model"); g._handle_android_back()
		check(not g.model_menu.visible and g.rebirth_dialog.visible, "Back closed both modals")
		g._handle_android_back()
	# Old schema migration preserves the current run without inventing unknown previous tours.
	var legacy: Dictionary = g._save_data().duplicate(true)
	legacy.erase("lifetime_deliveries"); legacy.erase("achievement_claimed")
	legacy["save_version"] = 10; legacy["last_saved_at"] = int(Time.get_unix_time_from_system()) + 60
	var file := FileAccess.open(g.SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(legacy)); file.close()
	var migrated = load("res://scenes/Main.tscn").instantiate(); root.add_child(migrated); migrated.set_process(false)
	check(migrated.lifetime_deliveries == g.dispatch.completed + g.dispatch.founder_completed and migrated.achievement_claimed.is_empty(), "Old save invented historical delivery counts or claims")
	check(migrated.motivation_level == g.motivation_level and migrated.motivation_stars == g.motivation_stars, "Migration changed premium progress")
	migrated.free()
	g._reset_progress()
	check(g.lifetime_deliveries == 0 and g.achievement_claimed.is_empty(), "Full reset retained achievements")
	g.free()
	if failures.is_empty(): print("Progression passed: one-time atomic claims, restart/prestige/reset, offline stars/lifetime, two-ratio card layout and modal navigation")
	quit(0 if failures.is_empty() else 1)
