extends SceneTree
var failures: Array[String]=[]
func _initialize() -> void:call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok:failures.append(why);push_error(why)
func fresh():
	var g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false)
	g.feedback.set_process(false)
	g.sound_enabled=false;g.haptics_enabled=false
	g._reset_progress();g.rng.seed=4242;g._create_company("R5 Deneme",0)
	return g
func run() -> void:
	var g=fresh();var f=g.feedback
	check(not g.sound_enabled and not g.haptics_enabled,"New default must be quiet and haptics-off")
	var cash: int=g.money;var random_state: int=g.rng.state
	f.deliveries(5000,100);f._process(.01)
	check(f.displays==1 and "100 teslimat" in f.text_label.text and "+5K" in f.text_label.text,"Batch delivery failed to coalesce")
	check(f.sound_plays==0 and f.haptic_calls==0,"Disabled feedback produced sound or vibration")
	var child_count: int=f.get_child_count()
	for i in 49:f.deliveries(10,1);f._process(.1)
	check(f.displays==1,"Delivery banner exceeded 5second rate limit")
	f._process(.2)
	check(f.displays==2 and f.get_child_count()==child_count,"Delivery feedback leaked nodes or failed to flush aggregate")
	check(g.money==cash and g.rng.state==random_state,"Cosmetic notifications mutated money or RNG")
	f.clear();f.purchase("Birinci alım");f.purchase("İkinci alım");f.purchase("Üçüncü alım")
	check(f.purchase_batch==3 and "3 yatırım" in f.text_label.text,"Rapid purchases stacked instead of reusing banner")
	f.clear();var shown: int=f.displays
	g._advance_simulation(14400)
	check(f.displays==shown and f.pending_deliveries==0,"Offline/simulation batch replayed per-job effects")
	g.last_saved_at=int(Time.get_unix_time_from_system())-14400
	g._apply_offline_income()
	check(f.displays==shown and f.pending_deliveries==0,"Real offline entry replayed delivery effects")
	f.deliveries(20,1);g._open_settings();f._process(.01)
	check(not f.frame.visible and f.pending_deliveries==0,"Settings retained stale delivery notifications")
	g._toggle_sound()
	check(g.sound_enabled and f.sound_plays==1,"Sound opt-in did not play one bounded preview")
	var sounds: int=f.sound_plays
	for i in 10:f.play_sound("purchase")
	check(f.sound_plays==sounds,"Sound cooldown failed")
	g._toggle_sound();f.sound_cooldown=0;f.play_sound("delivery")
	check(f.sound_plays==sounds and not f.player.playing,"Mute did not stop/block audio")
	g._close_settings();g.return_overlay.hide();f.clear()
	g._notification(g.NOTIFICATION_APPLICATION_PAUSED)
	f.deliveries(20,1);f.purchase("Gizli alım");f._process(.1)
	check(not f.frame.visible and f.pending_deliveries==0,"Background app retained effects")
	g.application_suspended=false
	# Compare real event processing with the cosmetic hook disconnected.
	var a=fresh();var b=fresh()
	a.feedback=null
	for i in 600:
		a._process(.5);b._process(.5);b.feedback._process(.5)
	check(a.money==b.money and a.total_earned==b.total_earned and a.dispatch.to_save()==b.dispatch.to_save() and a.rng.state==b.rng.state,"Feedback altered deterministic gameplay")
	a.free();b.free()
	g.last_saved_at=int(Time.get_unix_time_from_system())+60
	g.sound_enabled=true;g.haptics_enabled=true;g._save_game();g.free()
	g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false);g.feedback.set_process(false)
	check(g.sound_enabled and g.haptics_enabled and "AÇIK" in g.sound_button.text and "AÇIK" in g.haptics_button.text,"Feedback preferences lost on restart")
	check(g.feedback.displays==0 and g.feedback.sound_plays==0,"Loading preferences/offline save produced effects")
	g._start_playing();g.return_overlay.hide();g.unlocked_district_index=6;g.run_earned=g.run_prestige_target;g._rebirth()
	check(g.sound_enabled and g.haptics_enabled,"Prestige reset audio preferences")
	g._reset_progress()
	check(g.sound_enabled and g.haptics_enabled,"Progress reset changed accessibility preferences")
	for height in [800,1040]:
		root.size=Vector2i(480,height);await process_frame
		check(Rect2(Vector2.ZERO,g.size).encloses(g.settings_panel.get_rect()),"Feedback settings escaped phone viewport")
		for button in [g.sound_button,g.haptics_button]:check(button.size.y>=44,"Feedback settings target smaller than44px")
		check(g.feedback.mouse_filter==Control.MOUSE_FILTER_IGNORE and g.feedback.frame.mouse_filter==Control.MOUSE_FILTER_IGNORE,"Feedback blocks map touches")
		check(Rect2(Vector2.ZERO,g.size).encloses(g.feedback.frame.get_rect()),"Banner escaped viewport")
	g.free()
	if failures.is_empty():print("Feedback passed: bounded batch/purchase notifications, cooldowns, mute/background/offline suppression, unchanged earnings/RNG, persisted preferences and phone layouts; physical Android haptics not tested")
	quit(0 if failures.is_empty() else 1)
