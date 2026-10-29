extends SceneTree
const Before = preload("res://tools/r2_baseline_probe.gd")
const After = preload("res://tools/r1_probe_game.gd")
var failures: Array[String] = []
var measurements: Array[Dictionary] = []
func _initialize() -> void: call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok:
		failures.append(why);push_error(why)
func fresh(script: Script, profile: String = "new_company"):
	var g = script.new();root.add_child(g);g.set_process(false)
	g._reset_progress();g.rng.seed=4242;g._create_company("R2 Ölçüm",0)
	if profile!="new_company":
		g.unlocked_district_index=6;g._activate_district(6)
		if profile=="developed_fleet":
			g.staff_counts.assign([8,6,4,2]);g.workers=20
			g.service_level=10;g.bonus_level=3;g.comfort_level=5;g.operations_level=5
			g.dispatch.reset();g._seed_company_job()
	return g
func equal(a: Variant,b: Variant) -> bool:
	if (a is float or a is int) and (b is float or b is int):return absf(float(a)-float(b))<0.000001
	if a is Dictionary and b is Dictionary:
		if a.size()!=b.size():return false
		for key in a:
			if not b.has(key) or not equal(a[key],b[key]):return false
		return true
	if a is Array and b is Array:
		if a.size()!=b.size():return false
		for i in a.size():
			if not equal(a[i],b[i]):return false
		return true
	return a==b
func gameplay(g) -> Dictionary:
	return {"cash":g.money,"total":g.total_earned,"run":g.run_earned,"dispatch":g.dispatch.to_save(),"rng":str(g.rng.state),"opened":g.unlocked_district_index}
func routes() -> void:
	var a=fresh(Before);var b=fresh(After)
	a.unlocked_district_index=6;b.unlocked_district_index=6
	var quotes:=0
	for district in 7:
		a._activate_district(district);b._activate_district(district)
		for pickup in a.PICKUPS.size():
			for drop in a.DROPS.size():
				check(equal(a._order_quote(pickup,drop),b._order_quote(pickup,drop)),"Route quote changed region %d pair %d/%d"%[district,pickup,drop])
				quotes+=1
		check(b.route_distance_cache.size()<=a.PICKUPS.size()*a.DROPS.size(),"Route cache unexpectedly unbounded")
		var quote: Dictionary = b._order_quote(1,2)
		a.money=10000;b.money=10000
		a._buy_service();b._buy_service()
		a._buy_company_upgrade("comfort");b._buy_company_upgrade("comfort")
		check(equal(a._order_quote(1,2),b._order_quote(1,2)),"Cached geometry froze upgraded price/speed")
		check(int(b._order_quote(1,2)["paid"])>int(quote["paid"]),"Price failed to update over route cache")
		b._build_roads()
		check(b.route_distance_cache.is_empty(),"Rebuilt graph retained stale geometry")
	measurements.append({"all_pair_quotes_checked":quotes,"districts":7,"upgraded_quotes":7,"geometry_invalidation":true})
	a.free();b.free()
func timing() -> void:
	for profile in ["new_company","last_district_understaffed","developed_fleet"]:
		var before_ms: Array[float]=[];var after_ms: Array[float]=[]
		var final_state: Dictionary
		for repeat in 3:
			var a=fresh(Before,profile);var b=fresh(After,profile)
			var t:=Time.get_ticks_usec();a._advance_simulation(14400);before_ms.append((Time.get_ticks_usec()-t)/1000.0)
			t=Time.get_ticks_usec();b._advance_simulation(14400);after_ms.append((Time.get_ticks_usec()-t)/1000.0)
			check(equal(gameplay(a),gameplay(b)),"4h baseline/current earnings, queue or RNG differed: "+profile)
			final_state={"cash":b.money,"completed":b.dispatch.completed,"missed":b.dispatch.missed}
			a.free();b.free()
		var a=fresh(Before,profile);var b=fresh(After,profile)
		var before_calls: int=a.checkpoint_requests;var after_calls: int=b.checkpoint_requests
		for frame in 9000:a._process(1.0/30.0);b._process(1.0/30.0)
		check(equal(gameplay(a),gameplay(b)),"30fps 5m process gameplay differed: "+profile)
		check(b.checkpoint_requests-after_calls<=10,"Periodic save budget exceeded in idle 5m")
		var row: Dictionary={"profile":profile,"simulated_hours":4,"before_3_runs_ms":before_ms,"after_3_runs_ms":after_ms,"five_minute_checkpoints_before":a.checkpoint_requests-before_calls,"five_minute_checkpoints_after":b.checkpoint_requests-after_calls,"ending_4h":final_state}
		measurements.append(row);print("R2 ",JSON.stringify(row))
		a.free();b.free()
func checkpoints() -> void:
	var g=fresh(After)
	g._advance_simulation(15)
	for action in ["purchase","district","menu","pause","close"]:
		var count: int=g.checkpoint_requests
		match action:
			"purchase":g.money=1000;g._hire_worker(0)
			"district":g.unlocked_district_index=1;g._activate_district(1)
			"menu":g._back_to_menu()
			"pause":g._notification(g.NOTIFICATION_APPLICATION_PAUSED)
			"close":g._notification(g.NOTIFICATION_WM_CLOSE_REQUEST)
		check(g.checkpoint_requests>count,"Critical checkpoint missing: "+action)
	g.free()
func real_restart() -> void:
	var g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false)
	g._reset_progress();g.rng.seed=4242;g._create_company("R2 Kayıt",3)
	g.last_saved_at=int(Time.get_unix_time_from_system())+60
	g.money=1000;g._hire_worker(0)
	var purchased:=gameplay(g)
	g.free()
	g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false)
	check(equal(gameplay(g),purchased) and g.staff_counts==[2,0,0,0],"Purchase lost or duplicated on immediate restart")
	g._start_playing()
	g._advance_simulation(17);g._back_to_menu()
	check(equal(g.save_store.load_record(g.SAVE_PATH)["dispatch"],g.dispatch.to_save()),"Menu did not persist current jobs")
	g._notification(g.NOTIFICATION_APPLICATION_PAUSED)
	check(g.save_store.load_record(g.SAVE_PATH)["money"]==g.money,"Pause did not persist earned cash")
	var before_resume:=gameplay(g)
	g._notification(g.NOTIFICATION_APPLICATION_RESUMED)
	check(equal(gameplay(g),before_resume),"Zero-elapsed resume double-credited")
	g._notification(g.NOTIFICATION_WM_CLOSE_REQUEST)
	check(g.save_store.load_record(g.SAVE_PATH)["money"]==g.money,"Close did not persist cash")
	# Model an OS kill between checkpoints: disk remains at the earlier state;
	# loading replays elapsed time from that checkpoint, not on top of unsaved RAM.
	var record: Dictionary=g._save_data().duplicate(true)
	record["last_saved_at"]=int(Time.get_unix_time_from_system())-60
	check(g.save_store.write_record(g.SAVE_PATH,record),"Could not stage checkpoint restart")
	g._advance_simulation(15)
	g.free()
	g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false)
	var reference=fresh(After)
	for field in ["money","total_earned","run_earned","service_level","bonus_level","comfort_level","operations_level","rebirth_count","district_index","unlocked_district_index","workers","deliveries"]:reference.set(field,record[field])
	reference.staff_counts.assign(record["staff_counts"])
	reference.dispatch.restore(record["dispatch"]);reference.rng.state=int(record["rng_state"]);reference._build_roads()
	reference._advance_simulation(g.last_saved_at-int(record["last_saved_at"]))
	check(equal(gameplay(reference),gameplay(g)),"Checkpoint replay after simulated OS kill changed earnings or jobs")
	reference.free();g.free()
func run() -> void:
	routes();timing();checkpoints();real_restart()
	var file:=FileAccess.open("res://build/r2/results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"measurements":measurements,"failures":failures,"scope":"Desktop headless, isolated APPDATA, real 0.18 baseline versus current. Timing excludes startup and render; not Android latency."},"  "));file.close()
	print("R2 verification failures=",failures.size())
	quit(0 if failures.is_empty() else 1)
