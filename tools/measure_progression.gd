extends "res://tools/measure_r4.gd"
var scenarios: Array[Dictionary] = []
func measure() -> void:
	for seed_value in [4242, 7391]:
		for model in ["standard", "neighborhood", "express", "distribution"]:
			scenarios.append(sample(model, seed_value, true, 30))
		scenarios.append(sample("standard", seed_value, false, 30))
	# Sparse visits: ten-minute investment windows, not forced continuous play.
	scenarios.append(sample("express", 4242, true, 600))
	var file := FileAccess.open("res://build/progression-balance.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"scenarios": scenarios, "failures": failures}, "\t")); file.close()
	print("Progression balance finished: ", scenarios.size(), " scenarios; failures=", failures)
	quit(0 if failures.is_empty() else 1)
func sample(model: String, seed_value: int, use_motivation: bool, cadence: int) -> Dictionary:
	var g = fresh(seed_value)
	var elapsed := 0
	var start := 0
	var first_motivation := -1
	var tours: Array[Dictionary] = []
	while tours.size() < 5 and elapsed < 48 * 3600:
		g._advance_simulation(cadence); elapsed += cadence
		if use_motivation:
			for item in g.Achievements.ITEMS:
				if not g.achievement_claimed.has(item[0]) and g.Achievements.progress(g, item) >= int(item[3]): g._claim_achievement(str(item[0]))
			if g.motivation_level < 20 and g.motivation_stars >= g._motivation_cost():
				g._buy_motivation()
				if first_motivation < 0: first_motivation = elapsed
		if g._rebirth_ready():
			var row := state(g)
			row.merge({"tour":tours.size()+1, "seconds":elapsed-start, "motivation":g.motivation_level, "stars":g.motivation_stars, "lifetime_deliveries":g.lifetime_deliveries, "claims":g.achievement_claimed.size()})
			tours.append(row)
			print("Progression ",model," seed=",seed_value," motivation=",use_motivation," cadence=",cadence," tour=",tours.size()," minutes=",(elapsed-start)/60.0," level=",g.motivation_level)
			if tours.size() == 5: break
			g.specialization_choice.select(g.Specialization.IDS.find(model)); g._rebirth(); start = elapsed
		select_district(g)
		for attempt in 3:
			var choices := options(g, "balanced")
			var selected: Dictionary = {}
			for item in choices:
				if float(item["gain_per_minute"]) > 0.000001 and g.money >= int(item["cost"]): selected = item; break
			if selected.is_empty(): break
			buy(g, selected)
	expect(tours.size() == 5, "Progression scenario timed out")
	var result := {"model":model, "seed":seed_value, "motivation_enabled":use_motivation, "cadence":cadence, "first_motivation_seconds":first_motivation, "tours":tours}
	g.free()
	return result
