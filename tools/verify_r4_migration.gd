extends SceneTree
const Old = preload("res://tools/r4_baseline_probe.gd")
var failures: Array[String]=[]
var results: Array[Dictionary]=[]
func _initialize() -> void:call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok:failures.append(why);push_error(why)
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
func run() -> void:
	var old=Old.new();root.add_child(old);old.set_process(false)
	old._reset_progress();old.rng.seed=4242;old._create_company("Eski Martı",8)
	old.staff_counts.assign([5,3,2,1]);old.workers=11;old.service_level=4;old.bonus_level=3;old.comfort_level=7;old.operations_level=6
	old.unlocked_district_index=6;old._activate_district(4)
	old.dispatch.reset();old._seed_company_job();old._advance_simulation(300)
	old.money=12345;old.run_earned=230000;old.total_earned=456789
	var before: Dictionary=old._save_data().duplicate(true)
	before["last_saved_at"]=int(Time.get_unix_time_from_system())-600
	check(old.save_store.write_record(old.SAVE_PATH,before),"Cannot write frozen legacy record")
	var old_speeds: Array=old._company_speeds().duplicate()
	var game=load("res://scenes/Main.tscn").instantiate();root.add_child(game);game.set_process(false)
	var elapsed: int=game.return_summary.get("seconds",0)
	check(elapsed>=600 and elapsed<=602,"Legacy absence did not settle expected interval")
	old._advance_simulation(elapsed)
	check(game.money==old.money and game.total_earned==old.total_earned and game.run_earned==old.run_earned,"Legacy offline earnings settled using new economy")
	check(equivalent(game.dispatch.to_save(),old.dispatch.to_save()) and game.rng.state==old.rng.state,"Migration changed accepted jobs or order RNG")
	check(game.simulation_economy_version==7 and game.run_prestige_target==220000,"Legacy run target was increased")
	check(game.staff_counts==old.staff_counts and game.company_name=="Eski Martı" and game.company_logo==8,"Migration lost fleet/identity")
	check(equivalent(game.legacy_speed_floor,old_speeds),"Legacy purchased speed floor wrong")
	check(game._rebirth_ready() and game.district_index==4,"Legacy eligible player must prestige outside final district")
	var record: Dictionary=game._save_data().duplicate(true)
	game.last_saved_at=int(Time.get_unix_time_from_system())+60;game._save_game();game.free()
	game=load("res://scenes/Main.tscn").instantiate();root.add_child(game);game.set_process(false)
	check(game.money==int(record["money"]) and equivalent(game.legacy_speed_floor,record["legacy_speed_floor"]) and game.run_prestige_target==220000,"Reload repeated migration/credit or lost protected run state")
	game._rebirth()
	check(game.run_prestige_target==game.Economy.REBIRTH_THRESHOLD and game.legacy_speed_floor.is_empty() and game.staff_counts==[1,0,0,0],"New tour retained legacy economy protection or wrong target/fleet")
	var new_record: Dictionary=game.save_store.load_record(game.SAVE_PATH)
	check(equivalent(new_record["dispatch"],game.dispatch.to_save()) and new_record["run_prestige_target"]==game.run_prestige_target,"Committed prestige does not match live new tour")
	results.append({"legacy_absence_seconds":elapsed,"legacy_target":220000,"new_tour_target":game.run_prestige_target,"legacy_speeds":old_speeds,"checks":"frozen old runtime settlement / exact jobs+RNG / identity+fleet / existing target / restart idempotence / prestige transaction"})
	old.free();game.free()
	var file:=FileAccess.open("res://build/r4/migration-results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"results":results,"failures":failures},"  "));file.close()
	print("R4 frozen-source migration verification failures=",failures.size())
	quit(0 if failures.is_empty() else 1)
