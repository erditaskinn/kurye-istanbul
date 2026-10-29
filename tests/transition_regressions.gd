extends SceneTree
var failures: Array[String]=[]
func _initialize() -> void:call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok:failures.append(why);push_error(why)
func fresh():
	var g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false);g.feedback.set_process(false)
	g._reset_progress();g.rng.seed=4242;g._create_company("R6 Şirket",0)
	return g
func run() -> void:
	var g=fresh()
	for tab in 3:
		g.company_ui.open_tab(tab);g._handle_android_back()
		check(not g.company_ui.sheet.visible and not g.menu_overlay.visible,"Back from drawer must not exit gameplay")
	g.company_ui.open_tab(3);check(g.settings_overlay.visible,"Settings icon failed")
	g._handle_android_back();check(not g.settings_overlay.visible and not g.menu_overlay.visible,"Back from settings must return to game")
	g._toggle_district_panel();g._toggle_album();g._handle_android_back()
	check(g.district_panel.visible and not g.album_panel.visible,"Back from album must preserve district picker")
	g._handle_android_back();check(not g.district_panel.visible,"Back from district picker failed")
	g._toggle_guide();check(g.guide_panel.visible and g.guide_seen,"Return-screen guide must remain reachable")
	g._handle_android_back();check(not g.guide_panel.visible,"Back from live guide failed")
	# A capped long absence must equal the same checkpoint advanced by4h.
	var reference=fresh()
	g.last_saved_at=int(Time.get_unix_time_from_system())-28800
	g._apply_offline_income();reference._advance_simulation(14400)
	check(g.money==reference.money and g.dispatch.completed==reference.dispatch.completed and g.rng.state==reference.rng.state,"Eight-hour absence did not cap to the same4h simulation")
	check(int(g.return_summary.get("seconds",0))==14400 and int(g.return_summary.get("capped",0))>0,"Capped return summary inaccurate")
	g.company_ui.open_tab(0);g._show_return_summary()
	check(g.return_overlay.visible and not g.company_ui.sheet.visible,"Return summary must close underlying investment drawer")
	g._handle_android_back();check(not g.return_overlay.visible,"Back failed to dismiss return summary")
	g.last_saved_at=int(Time.get_unix_time_from_system())+3600
	var cash: int=g.money;var random_state: int=g.rng.state
	g._apply_offline_income();check(g.money==cash and g.rng.state==random_state,"Backward clock produced windfall or negative replay")
	g._notification(g.NOTIFICATION_APPLICATION_PAUSED);g._process(120)
	check(g.application_suspended and g.money==cash,"Paused app kept processing")
	g._notification(g.NOTIFICATION_APPLICATION_RESUMED)
	check(not g.application_suspended and g.money==cash,"Zero-elapsed resume paid twice")
	g.unlocked_district_index=6;g.run_earned=g.run_prestige_target
	var state: Dictionary=g._save_data().duplicate(true)
	var store=g.save_store
	g.save_store=load("res://tests/failing_save_store.gd").new()
	g._rebirth()
	check(g._save_data()==state,"Failed prestige commit mutated progress, identity or jobs")
	g.save_store=store
	g._confirm_rebirth();g._handle_android_back()
	check(not g.rebirth_dialog.visible and g.rebirth_count==0,"Back from prestige confirmation reset progress")
	g._request_reset();g._handle_android_back()
	check(not g.reset_dialog.visible and g.money==cash,"Back from reset confirmation reset progress")
	g.free();reference.free()
	if failures.is_empty():print("Transition regressions passed: drawers/settings/district/album/live guide,4hcap, return stacking, backward clock, pause/resume and failed/cancelled destructive transactions")
	quit(0 if failures.is_empty() else 1)
