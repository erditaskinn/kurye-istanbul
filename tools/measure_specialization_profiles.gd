extends SceneTree
const Probe = preload("res://tools/r1_probe_game.gd")
var rows: Array[Dictionary] = []
func _initialize() -> void: call_deferred("run")
func run() -> void:
	for role in [1,2,3]:
		for district in [0,3,6]:
			for model in ["standard","neighborhood","express","distribution"]:
				var g = Probe.new(); root.add_child(g); g.set_process(false)
				g._reset_progress(); g.rng.seed = 4242; g._create_company("Uzmanlık Ölçümü", 0)
				g.rebirth_count = 2; g.specialization_id = model
				g.district_index = district; g.unlocked_district_index = 6; g._build_roads()
				g.staff_counts.assign([0,0,0,0]); g.staff_counts[role] = 1; g.workers = 1
				g.service_level = 8; g.comfort_level = 4; g.operations_level = 4
				g.dispatch.reset(); var before: int = g.money
				g._advance_simulation(14400)
				rows.append({"role":role,"district":district,"model":model,"cash":g.money-before,"completed":g.dispatch.completed,"capacity":g._production_snapshot()["capacity"]})
				g.free()
	var file := FileAccess.open("res://build/specialization-profiles.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(rows,"\t")); file.close()
	print("Measured36 real4h role/district/model profiles")
	quit()
