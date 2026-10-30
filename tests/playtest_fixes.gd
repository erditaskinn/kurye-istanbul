extends SceneTree
var failures: Array[String] = []
func _initialize() -> void: call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok: failures.append(why); push_error(why)
func fresh():
	var g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false);g.feedback.set_process(false)
	g._reset_progress();g.rng.seed=4242;g._create_company("Okunaklı Şirket",0)
	return g
func run() -> void:
	var expected := 0
	for route in ["plain","sound","haptics","menu","pause"]:
		var g=fresh();g._open_settings();g.last_saved_at=int(Time.get_unix_time_from_system())-120
		var before: int=g.money
		match route:
			"sound":g._toggle_sound()
			"haptics":g._toggle_haptics()
			"menu":g._back_to_menu();g._start_playing()
			"pause":g._notification(g.NOTIFICATION_APPLICATION_PAUSED);g._notification(g.NOTIFICATION_APPLICATION_RESUMED)
		if g.settings_overlay.visible:g._close_settings()
		var earned: int=g.money-before
		if route=="plain":expected=earned
		check(expected>0 and earned==expected,"Settings time mismatch: "+route)
		var cash: int=g.money
		g._open_settings();g._close_settings()
		check(g.money==cash,"Same settings duration paid twice")
		g.free()
	var g=fresh();g._advance_simulation(600);g._refresh_ui()
	check(g.deliveries_label.tooltip_text.begins_with(str(g.dispatch.completed)),"HUD tooltip differs from displayed team count")
	for character in "ÇĞİÖŞÜçğıöşü₺":check(g.header_font.has_char(character.unicode_at(0)),"Font missing glyph: "+character)
	g._toggle_guide()
	check("Konfor" not in g.guide_body.text and "yıldız" in g.guide_body.text,"Guide still names old motivation")
	g._toggle_guide()
	g.service_level=50;g.staff_counts.assign([100,100,100,100]);g.workers=400;g.unlocked_district_index=6;g.district_index=0
	g._refresh_return_choices()
	var districts:=0
	for row in g.return_choices:if row["kind"]=="district":districts+=1
	check(districts==1,"Duplicate district recommendations remain")
	for height in [800,1040]:
		root.size=Vector2i(480,height);await process_frame
		g.company_ui.open_tab(1);await process_frame
		check(g.company_ui.motivation_hint.is_visible_in_tree() and g.company_ui.motivation_hint.size.y>=44,"Star earning link hidden or too small")
		check(g.company_ui.reward_badge.visible,"Ready achievement badge missing")
		g.company_ui.close_all()
	g.free()
	if failures.is_empty():print("Playtest fixes passed: settings sound/haptics/menu/pause equal credit once, HUD scope, font glyphs, guide, unique recommendations and reward discovery")
	quit(0 if failures.is_empty() else 1)
