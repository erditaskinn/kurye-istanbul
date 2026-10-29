extends SceneTree
const Previous = preload("res://build/r6/baseline/Main.tscn")
const Current = preload("res://scenes/Main.tscn")
var failures: Array[String]=[]
var results: Array[Dictionary]=[]
func _initialize() -> void:call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok:failures.append(why);push_error(why)
func count_nodes(node: Node) -> int:
	var count:=1
	for child in node.get_children():count+=count_nodes(child)
	return count
func normalize(value: Variant) -> Variant:
	if value is Dictionary:
		var output: Dictionary={}
		for key in value:
			if key not in ["unix_seconds","last_saved_at"]:output[key]=normalize(value[key])
		return output
	if value is Array:
		var output: Array=[]
		for item in value:output.append(normalize(item))
		return output
	return value
func equivalent(a: Variant,b: Variant) -> bool:
	if (a is float or a is int) and (b is float or b is int):return absf(float(a)-float(b))<0.00001
	if a is Dictionary and b is Dictionary:
		if a.size()!=b.size():return false
		for key in a:
			if not b.has(key) or not equivalent(a[key],b[key]):return false
		return true
	if a is Array and b is Array:
		if a.size()!=b.size():return false
		for i in a.size():
			if not equivalent(a[i],b[i]):return false
		return true
	return a==b
func stage(profile: String) -> Dictionary:
	var g=Previous.instantiate();root.add_child(g);g.set_process(false);g.feedback.set_process(false)
	g._reset_progress();g.rng.seed=4242;g._create_company("Martı Kurye",0)
	if profile!="fresh":
		g.money=20000;g.service_level=6;g.bonus_level=3;g.comfort_level=4;g.operations_level=3
		g.staff_counts.assign([3,2,2,1]);g.workers=8;g.unlocked_district_index=6;g._activate_district(4)
		g.dispatch.reset();g._seed_company_job();g._advance_simulation(300)
	if profile.begins_with("legacy"):
		g.simulation_economy_version=int(profile.trim_prefix("legacy"));g.vehicle=2;g.dispatch.reset()
		if g.simulation_economy_version<6:g._seed_founder_job()
		else:g._seed_company_job()
	var record: Dictionary=g._save_data().duplicate(true)
	record["last_saved_at"]=int(Time.get_unix_time_from_system())+3600
	if profile.begins_with("legacy"):
		var version:=int(profile.trim_prefix("legacy"))
		record["economy_version"]=version
		record["save_version"]={0:0,2:4,5:6,6:7}[version]
		record.erase("legacy_speed_floor");record.erase("run_prestige_target")
		if version<6:record.erase("brand_ready");record.erase("company_name");record.erase("company_logo")
	g.free()
	return record
func load_record(scene: PackedScene, record: Dictionary):
	var data:=record.duplicate(true)
	if not data.has("save_version"):data["save_version"]=8
	# Preserve the old schema number; write_record would upgrade it before load.
	var file:=FileAccess.open("user://kurye_save.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(data));file.close()
	var g=scene.instantiate();root.add_child(g);g.set_process(false);g.feedback.set_process(false)
	return g
func run() -> void:
	for profile in ["fresh","grown","legacy0","legacy2","legacy5","legacy6"]:
		var record:=stage(profile)
		var before=load_record(Previous,record)
		var after=load_record(Current,record)
		check(equivalent(normalize(before._save_data()),normalize(after._save_data())),"R6 load/migration state differs: "+profile)
		var before_nodes:=count_nodes(before);var after_nodes:=count_nodes(after)
		check(after_nodes<before_nodes,"Legacy controls still instantiated")
		before._advance_simulation(14400);after._advance_simulation(14400)
		check(equivalent(normalize(before._save_data()),normalize(after._save_data())),"R6 4h progression/RNG/jobs/metrics differs: "+profile)
		results.append({"profile":profile,"load_and_4h_state_equal":true,"nodes_before":before_nodes,"nodes_after":after_nodes})
		before.free();after.free()
	var file:=FileAccess.open("res://build/r6/state-results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"results":results,"failures":failures,"excluded_fields":"only wall-clock last_saved_at and event unix_seconds; economic event times/RNG retained"},"  "));file.close()
	print("R6 frozen0.22/current state verification failures=",failures.size()," results=",JSON.stringify(results))
	quit(0 if failures.is_empty() else 1)
