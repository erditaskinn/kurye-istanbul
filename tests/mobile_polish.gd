extends SceneTree
var failures: Array[String] = []
class InspectStore extends "res://scripts/save_store.gd":
	var game: Control
	var locked := false
	func write_record(_path: String, _data: Dictionary) -> bool:
		locked = game.claim_in_progress and game.company_ui.achievement_rows["delivery10"]["button"].disabled
		game._claim_achievement("delivery10") # A re-entrant request must be ignored.
		return false
func _initialize() -> void: call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok: failures.append(why); push_error(why)
func fresh():
	var g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false);g.feedback.set_process(false)
	g._reset_progress();g.rng.seed=4242;g._create_company("Mobil Test",0)
	return g
func run() -> void:
	var g=fresh();g.lifetime_deliveries=10;g.company_ui.open_tab(5)
	var store=g.save_store
	var inspect=InspectStore.new();inspect.game=g;g.save_store=inspect
	g._claim_achievement("delivery10")
	check(inspect.locked and not g.claim_in_progress,"Claim did not lock during commit")
	check(g.motivation_stars==0 and not g.company_ui.achievement_rows["delivery10"]["button"].disabled,"Failed commit consumed reward or left button locked")
	g.save_store=store;g._claim_achievement("delivery10");g._claim_achievement("delivery10")
	check(g.motivation_stars==1 and g.company_ui.achievement_rows["delivery10"]["button"].disabled,"Double click duplicated reward")
	g.company_ui.close_all();g.unlocked_district_index=1;g.company_ui._process(0)
	check(g.company_ui.district_tip.visible,"First district tip missing")
	g.company_ui._first_district(true)
	check(g.district_tip_seen and g.district_panel.visible,"District tip did not open comparison")
	g._handle_android_back();g.company_ui._process(0)
	check(not g.company_ui.district_tip.visible,"Dismissed tip repeated")
	g.last_saved_at=int(Time.get_unix_time_from_system())+86400
	var cash: int=g.money;g._apply_offline_income()
	check(g.money==cash,"Backward wall clock paid income")
	var reference=fresh();g._reset_progress();g.rng.seed=4242;g._create_company("Mobil Test",0)
	g.last_saved_at=int(Time.get_unix_time_from_system())-10*86400
	g._apply_offline_income();reference._advance_simulation(14400)
	check(g.money==reference.money and g.rng.state==reference.rng.state,"Large forward clock bypassed4h cap")
	var stars: int=g.motivation_stars;cash=g.money;g._apply_offline_income()
	check(g.money==cash and g.motivation_stars==stars,"Immediate repeated resume paid twice")
	g.sound_enabled=true;g.feedback.sound_cooldown=0;g.feedback.play_sound("purchase")
	g._notification(g.NOTIFICATION_APPLICATION_PAUSED)
	check(g.application_suspended and not g.feedback.player.playing,"Background did not stop audio")
	var sounds: int=g.feedback.sound_plays
	g._notification(g.NOTIFICATION_APPLICATION_RESUMED)
	check(not g.application_suspended and g.feedback.sound_plays==sounds,"Resume replayed old sound")
	reference.free();g.free()
	for height in [800,1040]:
		for insets in [Vector4(0,32,0,24),Vector4(24,48,24,32)]:
			root.size=Vector2i(480,height);g=fresh()
			var safe:=Rect2(insets.x,insets.y,480-insets.x-insets.z,height-insets.y-insets.w)
			g._safe_layout(safe);await process_frame
			print("Safe rect=",safe," actual=",g.get_global_rect())
			check(safe.grow(0.01).encloses(g.get_global_rect()),"Root escaped safe area")
			for button in g.company_ui.nav:
				check(safe.grow(0.01).encloses(button.get_global_rect()),"Navigation overlaps notch/system bar")
			g.company_ui.open_tab(4);await process_frame
			check(safe.grow(0.01).encloses(g.company_ui.sheet.get_global_rect()),"Drawer escaped safe area")
			for row in g.company_ui.cards.values():
				for field in ["body","forecast","payback","timing"]:
					var label: Label=row[field]
					check(label.get_theme_font_size("font_size")*g.scale.x>=14,"Safe area shrank body text below14")
				check(row["buy"].get_theme_font_size("font_size")*g.scale.x>=14,"Safe area shrank price below14")
				check(row["buy"].size.x>=370,"Price button not full width")
				check("eksik" in row["buy"].text,"Unaffordable price missing shortfall")
			var active: StyleBoxFlat=g.company_ui.nav[0].get_theme_stylebox("normal")
			check(active.border_width_top==4 and g.company_ui.nav_markers[0].visible,"Active fleet highlight missing")
			check(g.company_ui.sheet_scroll.position.y+g.company_ui.sheet_scroll.size.y<=g.company_ui.sheet.size.y,"Scroll overlaps drawer bottom")
			g.free()
	if failures.is_empty():print("Mobile polish passed: safe area ratios/insets, claim lock/reentry/failure, first district tip, clock cap/rollback/replay, background audio and active nav")
	quit(0 if failures.is_empty() else 1)
