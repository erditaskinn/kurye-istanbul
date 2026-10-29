extends SceneTree
var failures: Array[String]=[]
func _initialize() -> void:call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok:failures.append(why);push_error(why)
func run() -> void:
	var g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false)
	g._reset_progress();g._create_company("Uzman Filo",0);g.money=1000000
	var cash: int=g.money
	g._buy_company_upgrade("bonus");g._buy_company_upgrade("operations")
	check(g.money==cash and g.bonus_level==0 and g.operations_level==0,"Locked upgrades charged money or changed levels")
	g.company_ui.open_tab(0)
	check(g.company_ui.cards["bonus"]["buy"].disabled and "3 çalışan" in g.company_ui.cards["bonus"]["payback"].text,"Prim unlock must be visible")
	g._hire_worker(2)
	check(g._upgrade_requirement("operations").is_empty(),"Motor must unlock operations")
	g._buy_company_upgrade("operations")
	g._hire_worker(1)
	check(g._upgrade_requirement("bonus").is_empty(),"Third worker must unlock prim")
	g._buy_company_upgrade("bonus")
	check(g.operations_level==1 and g.bonus_level==1,"Unlocked upgrades failed to apply")
	var rural: Array=g.Economy.company_speeds(0,0,0)
	var urban: Array=g.Economy.company_speeds(6,0,0)
	check(float(rural[2])>float(rural[3]) and float(urban[3])>float(urban[2]),"Motor/car specialization has no district tradeoff")
	for role in 4:
		var comfort: Array=g.Economy.company_speeds(6,1,0)
		var operations: Array=g.Economy.company_speeds(6,0,1)
		check(is_equal_approx(float(comfort[role])/float(urban[role]),1+g.Economy.COMFORT_ROLE_BONUS[role]),"Comfort role effect mismatch")
		check(is_equal_approx(float(operations[role])/float(urban[role]),1+g.Economy.OPERATIONS_ROLE_BONUS[role]),"Operations role effect mismatch")
	var floor_values: Array=g.Economy.company_speeds(6,20,20,6)
	for district in 7:
		var protected: Array=g.Economy.company_speeds(district,20,20,7,floor_values)
		for role in 4:check(float(protected[role])>=float(floor_values[role]),"Migrated purchased speed lost")
	g.unlocked_district_index=6;g.district_index=0
	g.run_earned=g.run_prestige_target-1
	check(not g._rebirth_ready(),"Prestige became ready below its revenue target")
	g.run_earned=g.run_prestige_target
	check(g._rebirth_ready(),"Prestige still requires selecting final district")
	g.unlocked_district_index=5
	check(not g._rebirth_ready(),"Prestige ignores final district unlock")
	g.free()
	if failures.is_empty():print("Economy7 passed: staged unlocks, uncharged locked buys, district vehicle tradeoff, role specialties, migration floors and prestige boundary")
	quit(0 if failures.is_empty() else 1)
