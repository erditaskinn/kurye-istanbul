extends SceneTree
var failures: Array[String] = []
func _initialize() -> void:
	call_deferred("check")
func expect(ok: bool, why: String) -> void:
	if not ok:
		failures.append(why)
		push_error(why)
func fresh(create: bool = true) -> Control:
	var g = load("res://scenes/Main.tscn").instantiate()
	root.add_child(g)
	g.set_process(false)
	g._reset_progress()
	if create: g._create_company("Deneme Kurye", 4)
	g.rng.seed = 4242
	return g
func check() -> void:
	var g = fresh(false)
	g._start_playing()
	expect(g.company_ui.creation.visible and not g.has_started and not g.brand_ready and g.dispatch.active.is_empty(), "Fresh game must require company identity before production")
	expect(not g._create_company(" ", 0) and g.company_ui.logo_buttons.size() == 9, "Name validation and nine logo choices required")
	g._create_company("  Martı Kurye  ", 8)
	expect(g.brand_ready and g.company_name == "Martı Kurye" and g.company_logo == 8 and g.staff_counts == [1,0,0,0] and g.workers == 1 and g.company, "Company must start free with one real walking courier")
	expect(g.dispatch.active.size() == 1 and g.dispatch.active[0]["role"] == 0 and g.dispatch.founder_job().is_empty(), "There must be no extra invisible founder")
	expect(g._staff_cost(0) == 150 and absf(float(g._production_snapshot()["capacity"]) - 2) < 0.001, "Free founding employee must not inflate hire cost or capacity")
	g._advance_simulation(60)
	expect(g.money > 60 and g.dispatch.completed > 0, "Fleet must generate real deliveries and credited income")
	g.money = 20000
	for role in 4: g._hire_worker(role)
	var job: Dictionary = g.dispatch.active[0].duplicate(true)
	var quote_before: Dictionary = g._order_quote(1,2)
	g._buy_company_upgrade("bonus")
	g._buy_company_upgrade("comfort")
	g._buy_company_upgrade("operations")
	g._buy_service()
	expect(int(g._order_quote(1,2)["paid"]) > int(quote_before["paid"]) and float(g._order_quote(1,2)["speed_profile"][0]) > 10, "Prim/service and comfort/operations must affect actual future quotes and speed")
	expect(g.dispatch.active[0] == job, "Accepted work must remain locked during upgrades")
	expect(g.staff_counts == [2,1,1,1] and g.workers == 5, "All four fleet types must be available immediately")
	for tab in 3:
		g.company_ui.open_tab(tab)
		expect(g.company_ui.sheet.visible and g.company_ui.sheet_tab == tab and not g._map_actions_allowed(), "Bottom tabs must show one drawer and block map touches")
		g._handle_android_back()
		expect(not g.company_ui.sheet.visible, "Back must close the company drawer")
	g._create_company("Yeni Ad", 2)
	expect(g.workers == 5, "Changing brand must not grant another free employee")
	g.last_saved_at = int(Time.get_unix_time_from_system()) + 60
	g._save_game()
	var cash: int = g.money
	g.free()
	g = load("res://scenes/Main.tscn").instantiate()
	root.add_child(g)
	g.set_process(false)
	expect(g.company_name == "Yeni Ad" and g.company_logo == 2 and g.money == cash and g.bonus_level == 1 and g.comfort_level == 1 and g.operations_level == 1 and g.staff_counts == [2,1,1,1], "Company identity, upgrades and fleet must survive restart exactly")
	g.run_earned = g.REBIRTH_THRESHOLD
	g._update_district()
	g._activate_district(6)
	g._rebirth()
	expect(g.company_name == "Yeni Ad" and g.company_logo == 2 and g.brand_ready and g.workers == 1 and g.staff_counts == [1,0,0,0] and g.bonus_level == 0 and g.comfort_level == 0 and g.operations_level == 0 and g.dispatch.founder_job().is_empty(), "New tour must retain brand and restart a real one-person company")
	var record: Dictionary = g.save_store.load_record(g.SAVE_PATH)
	expect(equivalent(record["dispatch"], g.dispatch.to_save()) and record["workers"] == 1, "Prestige transaction must match new live fleet")
	g.free()
	var a = fresh(); var b = fresh()
	a._advance_simulation(600)
	for i in 1200: b._advance_simulation(.5)
	expect(a.money == b.money and equivalent(a.dispatch.to_save(), b.dispatch.to_save()), "Company clock must be independent of batch size")
	var c = fresh()
	c.last_saved_at = int(Time.get_unix_time_from_system()) - 600
	var income: int = c._apply_offline_income()
	expect(c.money == a.money and income == c.money - 60 and equivalent(c.dispatch.to_save(), a.dispatch.to_save()), "Company offline and online production must match")
	var resume_cash: int = c.money
	c._apply_offline_income()
	expect(c.money == resume_cash, "Repeated company resume must not double-credit")
	c._notification(c.NOTIFICATION_APPLICATION_PAUSED)
	c._process(120)
	expect(c.money == resume_cash and c.application_suspended, "Mobile suspension must freeze company process")
	c._notification(c.NOTIFICATION_APPLICATION_RESUMED)
	c._show_return_summary()
	expect(c.return_overlay.visible and "Filo" in c.return_breakdown_label.text, "Company return must show fleet contribution")
	c._handle_android_back()
	expect(not c.return_overlay.visible, "Back must close visible company return summary")
	c.free(); a.free(); b.free()
	# A5 fleet/founder interval must settle before converting its founder slot.
	var ref = fresh()
	ref.simulation_economy_version = 5
	ref.vehicle = 2
	ref.company = true
	ref.staff_counts.assign([1,1,0,0]); ref.workers = 2
	ref.dispatch.reset(); ref._seed_founder_job()
	var old: Dictionary = ref._save_data().duplicate(true)
	old["economy_version"] = 5; old["save_version"] = 6
	old.erase("brand_ready"); old.erase("company_name")
	old["last_saved_at"] = int(Time.get_unix_time_from_system()) - 600
	ref._advance_simulation(600)
	var file := FileAccess.open("user://kurye_save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(old)); file.close()
	var migrated = load("res://scenes/Main.tscn").instantiate()
	root.add_child(migrated); migrated.set_process(false)
	expect(migrated.money == ref.money and migrated.total_earned == ref.total_earned and migrated.staff_counts == [1,1,1,0] and migrated.workers == 3 and not migrated.brand_ready, "Old absence and fleet must migrate once without currency loss or hidden founder")
	for work in migrated.dispatch.active: expect(work["role"] != 4, "Founder slot must convert into a real employee slot")
	migrated._create_company("Eski Şirket", 1)
	expect(migrated.workers == 3, "Branding migrated company must not add another employee")
	ref.free(); migrated.free()
	if failures.is_empty(): print("Company model passed: identity, nine logos, real fleet, upgrades, locked jobs, drawer/back, save/restart, prestige, clock and legacy migration")
	quit(0 if failures.is_empty() else 1)

func equivalent(a: Variant, b: Variant) -> bool:
	if (a is float or a is int) and (b is float or b is int):
		return absf(float(a) - float(b)) < 0.0001
	if a is Dictionary and b is Dictionary:
		if a.size() != b.size(): return false
		for key in a:
			if not b.has(key) or not equivalent(a[key], b[key]): return false
		return true
	if a is Array and b is Array:
		if a.size() != b.size(): return false
		for i in a.size():
			if not equivalent(a[i], b[i]): return false
		return true
	return a == b
