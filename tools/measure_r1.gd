extends SceneTree
const Probe = preload("res://tools/r1_probe_game.gd")
var failures: Array[String] = []
var results: Array[Dictionary] = []
var benchmarks: Array[Dictionary] = []
var probes: Array[Dictionary] = []
var district_checks: Array[Dictionary] = []
var max_tours := 5
func _initialize() -> void:
	call_deferred("measure")
func expect(ok: bool, why: String) -> void:
	if not ok:
		failures.append(why)
		push_error(why)
func fresh(seed_value: int = 4242):
	var g = Probe.new()
	root.add_child(g)
	g.set_process(false)
	g._reset_progress()
	g.rng.seed = seed_value
	g._create_company("R1 Ölçüm", 0)
	return g
func state(g) -> Dictionary:
	return {"cash":g.money,"revenue":g.run_earned,"staff":g.staff_counts.duplicate(),"service":g.service_level,"bonus":g.bonus_level,"comfort":g.comfort_level,"operations":g.operations_level,"district":g.district_index,"opened":g.unlocked_district_index,"completed":g.dispatch.completed,"missed":g.dispatch.missed,"queue":g.dispatch.pending.size(),"estimate":g._production_snapshot().duplicate(true)}
func options(g, policy: String) -> Array[Dictionary]:
	var before: Dictionary = g._production_snapshot()
	var choices: Array[Dictionary] = []
	for kind in ["worker","service","bonus","comfort","operations"]:
		var level: int = g.service_level if kind == "service" else (g.bonus_level if kind == "bonus" else (g.comfort_level if kind == "comfort" else g.operations_level))
		if kind != "worker" and level >= (50 if kind == "service" else 20): continue
		for role in (4 if kind == "worker" else 1):
			var after: Dictionary
			var cost := 0
			if kind == "worker" or kind == "service":
				var item: Dictionary = g._investment(kind,role)
				after = item["after"]
				cost = item["cost"]
			else:
				cost = g.Economy.team_bonus_cost(level) if kind == "bonus" else (g.Economy.comfort_cost(level) if kind == "comfort" else g.Economy.operations_cost(level))
				var field: String = str(kind) + "_level"
				g.set(field,level+1)
				after = g._production_snapshot()
				g.set(field,level)
			var gain: float = float(after["income"]) - float(before["income"])
			var payback: float = cost/gain if gain > 0.000001 else -1.0
			var preference := 1.0
			if policy == "service" and kind in ["service","bonus"]: preference = 1.8
			if policy == "fleet" and kind in ["worker","comfort","operations"]: preference = 1.8
			choices.append({"kind":kind,"role":role,"cost":cost,"gain_per_minute":gain,"payback_minutes":payback,"score":payback/preference if payback >= 0 else INF})
	choices.sort_custom(func(a: Dictionary,b: Dictionary)->bool: return float(a["score"]) < float(b["score"]))
	return choices
func buy(g, item: Dictionary) -> void:
	match str(item["kind"]):
		"worker": g._hire_worker(int(item["role"]))
		"service": g._buy_service()
		_: g._buy_company_upgrade(str(item["kind"]))
func select_district(g) -> void:
	var chosen: int = g.district_index
	var best: float = g._production_snapshot()["income"]
	for region in range(g.unlocked_district_index+1):
		var income: float = g._production_snapshot(-1,-1,-1,region)["income"]
		if income > best + 0.000001:
			chosen = region
			best = income
	g._activate_district(chosen)
func policy_sample(policy: String, seed_value: int, cadence: int = 30) -> Dictionary:
	var g = fresh(seed_value)
	var elapsed := 0
	var tour_start := 0
	var tours: Array[Dictionary] = []
	var purchases: Array[Dictionary] = []
	var milestones: Array[Dictionary] = []
	var ten_minutes: Dictionary = {}
	var previous_open := 0
	var first_purchase := -1
	var purchases_by_kind: Dictionary = {}
	var started := Time.get_ticks_usec()
	while tours.size() < max_tours and elapsed < 48*3600:
		g._advance_simulation(cadence)
		elapsed += cadence
		if g.unlocked_district_index > previous_open:
			milestones.append({"tour":tours.size()+1,"seconds":elapsed-tour_start,"opened":g.unlocked_district_index})
			previous_open = g.unlocked_district_index
		if g.unlocked_district_index == 6 and g.run_earned >= g.REBIRTH_THRESHOLD:
			var gate := state(g)
			gate["tour"] = tours.size()+1
			gate["seconds"] = elapsed-tour_start
			gate["current_gate_before_switch"] = g._rebirth_ready()
			gate["final_district_income"] = g._production_snapshot(-1,-1,-1,6)["income"]
			gate["income_drop_to_final"] = maxf(0,float(gate["estimate"]["income"])-float(gate["final_district_income"]))
			if policy=="roi" and seed_value==4242 and tours.size()+1 in [1,3,5]: district_probe(g,tours.size()+1)
			g._activate_district(6)
			expect(g._rebirth_ready(),"R1 prestige gate inconsistent")
			tours.append(gate)
			print("R1 tour ",policy," seed=",seed_value," cadence=",cadence," tour=",tours.size()," minutes=",snappedf((elapsed-tour_start)/60.0,0.01))
			if tours.size() == max_tours: break
			g._rebirth()
			expect(g.rebirth_count == tours.size(),"R1 real prestige commit failed")
			tour_start = elapsed
			previous_open = 0
		select_district(g)
		# Thirty-second automated decision windows; at most three purchases each.
		for attempt in 3:
			var candidates := options(g,policy)
			var chosen: Dictionary = {}
			for candidate in candidates:
				if float(candidate["gain_per_minute"]) <= 0.000001: continue
				if policy != "balanced" or g.money >= int(candidate["cost"]):
					chosen = candidate
					break
			if chosen.is_empty() or g.money < int(chosen["cost"]): break
			var entry := chosen.duplicate()
			entry.erase("score")
			entry["tour"] = tours.size()+1
			entry["seconds"] = elapsed-tour_start
			entry["district"] = g.district_index
			var key := str(chosen["kind"])+("_"+str(chosen["role"]) if chosen["kind"]=="worker" else "")
			purchases_by_kind[key] = int(purchases_by_kind.get(key,0))+1
			if first_purchase < 0: first_purchase = elapsed
			buy(g,chosen)
			purchases.append(entry)
		if elapsed == 600: ten_minutes = state(g)
	var result := {"policy":policy,"seed":seed_value,"decision_cadence_seconds":cadence,"first_purchase_seconds":first_purchase,"first_10_minutes":ten_minutes,"tours":tours,"district_unlock_observations":milestones,"purchases_by_kind":purchases_by_kind,"purchases":purchases,"runtime_ms":(Time.get_ticks_usec()-started)/1000.0,"checkpoint_requests_not_written":g.checkpoint_requests}
	expect(tours.size()==max_tours,"R1 policy timed out before all tours")
	g.free()
	return result
func clone_state(source):
	var target = fresh()
	for key in ["money","total_earned","run_earned","service_level","bonus_level","comfort_level","operations_level","rebirth_count","district_index","unlocked_district_index","workers","deliveries"]: target.set(key,source.get(key))
	target.staff_counts.assign(source.staff_counts)
	target.dispatch.restore(source.dispatch.to_save())
	target.local_metrics.restore(source.local_metrics.to_save())
	target.rng.state = source.rng.state
	target._build_roads()
	return target
func equivalent(a: Variant,b: Variant) -> bool:
	if (a is float or a is int) and (b is float or b is int): return absf(float(a)-float(b))<0.00001
	if a is Dictionary and b is Dictionary:
		if a.size()!=b.size(): return false
		for key in a:
			if not b.has(key) or not equivalent(a[key],b[key]): return false
		return true
	if a is Array and b is Array:
		if a.size()!=b.size(): return false
		for i in a.size():
			if not equivalent(a[i],b[i]): return false
		return true
	return a==b
func benchmark(profile: String) -> Dictionary:
	var source = fresh()
	if profile != "new_company":
		source.unlocked_district_index = 6
		source._activate_district(6)
		if profile == "developed_fleet":
			source.staff_counts.assign([8,6,4,2]); source.workers=20
			source.service_level=10;source.bonus_level=3;source.comfort_level=5;source.operations_level=5
			source.dispatch.reset();source._seed_company_job()
	var times: Array[float] = []
	var reference
	var output: Dictionary
	for repeat in 3:
		var g = clone_state(source)
		var start := Time.get_ticks_usec()
		g._advance_simulation(14400)
		times.append((Time.get_ticks_usec()-start)/1000.0)
		if repeat==0:
			reference=g
			output=state(g)
		else:
			expect(g.money==reference.money and equivalent(g.dispatch.to_save(),reference.dispatch.to_save()),"R1 deterministic 4h repeat mismatch")
			g.free()
	var segmented = clone_state(source)
	for i in 480: segmented._advance_simulation(30)
	expect(segmented.money==reference.money and equivalent(segmented.dispatch.to_save(),reference.dispatch.to_save()),"R1 4h batch versus 30s mismatch")
	var offline = clone_state(source)
	offline.last_saved_at=int(Time.get_unix_time_from_system())-14400
	var start := Time.get_ticks_usec()
	var earned: int = offline._apply_offline_income()
	var offline_ms := (Time.get_ticks_usec()-start)/1000.0
	expect(offline.money==reference.money and equivalent(offline.dispatch.to_save(),reference.dispatch.to_save()),"R1 4h real offline entry mismatch")
	var before_repeat: int = offline.money
	# A real second can pass during a >1s desktop benchmark. Fence new wall time
	# so this assertion tests a zero-elapsed resume rather than rejecting income
	# legitimately earned in that newly elapsed second.
	offline.last_saved_at = int(Time.get_unix_time_from_system()) + 2
	offline._apply_offline_income()
	expect(offline.money==before_repeat,"R1 offline repeated credit")
	var result := {"profile":profile,"synthetic_profile":profile!="new_company","simulated_seconds":14400,"three_batch_ms":times,"offline_entry_ms":offline_ms,"credited_income":earned,"ending":output,"memory_static_process_bytes":OS.get_static_memory_usage(),"equivalence_checks":"repeat / 30s segmented / real offline entry / zero-elapsed resume"}
	print("R1 benchmark ",profile," times_ms=",times," offline_ms=",offline_ms)
	for g in [source,reference,segmented,offline]: g.free()
	return result
func marginal_probe() -> void:
	var source = fresh()
	for profile in ["start","service_7","service_20","demand_saturated","full_queue"]:
		source._reset_progress();source._create_company("R1 Ölçüm",0);source.rng.seed=4242
		if profile=="service_7": source.service_level=7
		if profile=="service_20": source.service_level=20
		if profile=="demand_saturated": source.staff_counts.assign([4,0,0,0]);source.workers=4
		if profile=="full_queue": source._advance_simulation(3600)
		var offers := options(source,"roi")
		var measured: Array[Dictionary] = []
		for offer in offers:
			var a = clone_state(source)
			var b = clone_state(source)
			# Endow both clones equally solely to measure one purchase's marginal effect.
			a.money=1000000;b.money=1000000
			buy(b,offer)
			var differences: Dictionary = {}
			for seconds in [60,600,3600]:
				var amount := 60 if seconds==60 else (540 if seconds==600 else 3000)
				a._advance_simulation(amount);b._advance_simulation(amount)
				differences[str(seconds)] = b.total_earned-a.total_earned
			var row := offer.duplicate();row.erase("score");row["additional_revenue_at_seconds"]=differences
			measured.append(row)
			a.free();b.free()
		probes.append({"profile":profile,"initial":state(source),"offers":measured})
		save_results()
	source.free()
func district_probe(source, tour: int) -> void:
	var rows: Array[Dictionary] = []
	for region in 7:
		var g = clone_state(source)
		g._activate_district(region)
		var initial_cash: int = g.money
		g._advance_simulation(600)
		var immediate_income: float = (g.money-initial_cash)/10.0
		g._advance_simulation(900)
		var cash: int = g.money
		var missed: int = g.dispatch.missed
		g._advance_simulation(600)
		rows.append({"district":region,"immediate_10m_income_per_minute":immediate_income,"after_25m_settling_10m_income_per_minute":(g.money-cash)/10.0,"steady_missed_10m":g.dispatch.missed-missed,"ending_queue":g.dispatch.pending.size(),"stationary_estimate":g._production_snapshot()})
		g.free()
	district_checks.append({"tour":tour,"source":state(source),"districts":rows,"method":"Same naturally reached fleet and upgrades, no investment; preserve locked jobs when switching, first10m then15m additional settling then10m measurement"})
func save_results() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/balance"))
	var file := FileAccess.open("res://build/balance/r1-company-v6.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"economy_version":6,"save_schema":7,"game_version":"0.18.0-pixel-hud","hardware":OS.get_processor_name(),"policies":results,"benchmarks":benchmarks,"marginal_probes":probes,"district_checks":district_checks,"failures":failures,"limits":["Desktop headless Godot, not Android performance or human retention","Policy sweeps bypass routine disk writes, retain real prestige commit in isolated profile","Policies use stationary income estimates for selection; all earnings from actual event engine","Synthetic benchmark/marginal endowments are not natural progression","Unlock timestamps quantized by decision cadence"]},"  "))
	file.close()
func measure() -> void:
	for policy in ["balanced","roi","service","fleet"]:
		for seed_value in [42,4242]:
			results.append(policy_sample(policy,seed_value))
			save_results()
			await process_frame
	# A less frequent decision sample distinguishes automation from constant management.
	results.append(policy_sample("balanced",4242,600))
	for profile in ["new_company","last_district_understaffed","developed_fleet"]:
		benchmarks.append(benchmark(profile));save_results();await process_frame
	marginal_probe()
	save_results()
	print("R1 finished policies=",results.size()," benchmarks=",benchmarks.size()," probes=",probes.size()," failures=",failures.size())
	quit(0 if failures.is_empty() else 1)


