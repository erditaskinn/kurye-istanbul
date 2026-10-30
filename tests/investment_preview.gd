extends SceneTree
var failures: Array[String] = []
func _initialize() -> void: call_deferred("run")
func check(ok: bool, why: String) -> void:
	if not ok: failures.append(why);push_error(why)
func run() -> void:
	var g=load("res://scenes/Main.tscn").instantiate();root.add_child(g);g.set_process(false)
	g._reset_progress();g.rng.seed=4242;g._create_company("R3 Deneme",0)
	g.money=1000000000;g.unlocked_district_index=6
	g._hire_worker(0);g._hire_worker(2)
	for district in 7:
		g._activate_district(district)
		for kind in ["worker","service","bonus","comfort","operations"]:
			for role in (4 if kind=="worker" else 1):
				var record: Dictionary=g._save_data().duplicate(true)
				var rng_before: int=g.rng.state
				var offer: Dictionary=g._investment(kind,role)
				check(g._save_data()==record and g.rng.state==rng_before,"Preview mutated gameplay/save/RNG")
				var paid: int=g.money
				match kind:
					"worker":g._hire_worker(role)
					"service":g._buy_service()
					_:g._buy_company_upgrade(kind)
				check(g.money==paid-int(offer["cost"]),"Preview price did not match actual purchase")
				var actual: Dictionary=g._production_snapshot()
				check(absf(float(actual["income"])-float(offer["after"]["income"]))<0.000001,"Preview income did not match purchased state")
				check(absf(float(actual["capacity"])-float(offer["after"]["capacity"]))<0.000001,"Preview capacity did not match purchased state")
				check(g.dispatch.to_save()==record["dispatch"],"Purchase repriced or sped up accepted work")
	g._reset_progress();g._create_company("R3 Deneme",0)
	g.staff_counts.assign([4,0,0,0]);g.workers=4
	for kind in ["worker","comfort","operations"]:
		var offer: Dictionary=g._investment(kind,0)
		check(float(offer["gain"])==0 and float(offer["payback"])<0,"Demand-capped upgrade must not promise income or finite payback")
	g.company_ui.open_tab(0)
	check("Talep karşılanıyor" in g.company_ui.cards["comfort"]["payback"].text,"Zero contribution needs visible reason")
	g._reset_progress();g._create_company("R3 Deneme",0);g._advance_simulation(3600)
	check(g.dispatch.pending.size()==30 and g.dispatch.missed>0,"Queue test did not saturate")
	g.company_ui.open_tab(0)
	check("30 eski iş" in g.company_ui.cards["service"]["timing"].text,"Queue-locked delay must be visible")
	check(str(g.dispatch.missed) in g.company_ui.flow_note.text and "Bu tur" in g.company_ui.flow_note.text,"Missed demand needs count and time scope")
	g.service_level=7;g.company_ui.sync()
	check("9,09" in g.company_ui.cards["service"]["body"].text,"Service must show relative current-price increase at level7")
	g.service_level=50;g.bonus_level=20;g.comfort_level=20;g.operations_level=20
	g._refresh_ui()
	for key in ["service","bonus"]:
		check(g.company_ui.cards[key]["buy"].disabled and "tamamlandı" in g.company_ui.cards[key]["payback"].text.to_lower(),"Capped upgrade must not promise another purchase")
	for height in [800,1040]:
		root.size=Vector2i(480,height);await process_frame
		for tab in [4,0,2]:
			g.company_ui.open_tab(tab);await process_frame
			for card in g.company_ui.cards.values():
				var panel: Control=card["buy"].get_parent()
				check(card["buy"].size.y>=44,"Buy target smaller than44px")
				for key in ["body","forecast","payback","timing"]:
					var label: Label=card[key]
					check(Rect2(Vector2.ZERO,panel.size).encloses(label.get_rect()),"Investment label escaped card")
					check(label.get_line_count()*label.get_line_height()<=label.size.y+1,"Investment text overflowed card: "+key)
				g.company_ui.sheet_scroll.scroll_vertical=100000
				await process_frame
				check(g.company_ui.sheet_scroll.scroll_vertical>0,"Expanded investment sheet cannot scroll")
	g.free()
	if failures.is_empty():print("Investment preview passed: actual purchases across7districts, side-effect-free estimates, locked jobs, demand cap, queue delay, service percentage, caps and two phone ratios")
	quit(0 if failures.is_empty() else 1)
