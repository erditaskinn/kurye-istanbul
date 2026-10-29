extends SceneTree
const Probe = preload("res://tools/r1_probe_game.gd")
var results: Array[Dictionary] = []
var failures: Array[String] = []
func _initialize() -> void:
	call_deferred("measure")
func measure() -> void:
	for profile in ["new_company","developed_fleet"]:
		var g = Probe.new()
		root.add_child(g);g.set_process(false)
		g._reset_progress();g.rng.seed=4242;g._create_company("R1 IO",0)
		if profile=="developed_fleet":
			g.unlocked_district_index=6;g._activate_district(6)
			g.staff_counts.assign([8,6,4,2]);g.workers=20
			g.service_level=10;g.bonus_level=3;g.comfort_level=5;g.operations_level=5
			g.dispatch.reset();g._seed_company_job()
		var start_count: int = g.checkpoint_requests
		var start := Time.get_ticks_usec()
		for frame in 9000: g._process(1.0/30.0)
		var process_ms := (Time.get_ticks_usec()-start)/1000.0
		var calls: int = g.checkpoint_requests-start_count
		var times: Array[float] = []
		var data: Dictionary = g._save_data()
		data["last_saved_at"]=int(Time.get_unix_time_from_system())
		for repeat in 50:
			start=Time.get_ticks_usec()
			if not g.save_store.write_record("user://r1-save-benchmark.json",data): failures.append("Isolated real save failed")
			times.append((Time.get_ticks_usec()-start)/1000.0)
		times.sort()
		var total := 0.0
		for sample in times: total+=sample
		results.append({"profile":profile,"simulated_process_seconds":300,"fps":30,"checkpoint_requests":calls,"completed":g.dispatch.completed,"process_without_disk_ms":process_ms,"fixed_snapshot_save_bytes":JSON.stringify(data).to_utf8_buffer().size(),"real_50_saves_mean_ms":total/50,"real_50_saves_median_ms":times[25],"real_50_saves_p95_ms":times[47],"real_50_saves_max_ms":times[-1],"limitations":"Desktop temporary profile filesystem; headless process-loop capture excludes real disk writes, separate save benchmark uses fixed end snapshot; not Android flash latency"})
		print("R1 IO ",profile," checkpoints/5min=",calls," deliveries=",g.dispatch.completed," save_mean_ms=",total/50)
		g.free()
	var file := FileAccess.open("res://build/balance/r1-io-baseline.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"results":results,"failures":failures},"  "));file.close()
	quit(0 if failures.is_empty() else 1)
