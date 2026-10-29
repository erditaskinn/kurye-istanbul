extends SceneTree

func _initialize() -> void:
	call_deferred("run_check")

func run_check() -> void:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	if game.district_index != 0 or game.rebirth_count != 0 or game.run_earned != 0:
		_fail("New game did not begin in the quiet district")
		return
	game._rebirth()
	if game.rebirth_count != 0:
		_fail("Rebirth was available before reaching the goal")
		return
	if game.DISTRICTS != ["Şile", "Beykoz", "Üsküdar", "Kadıköy", "Beşiktaş", "Şişli", "Beyoğlu"]:
		_fail("District route is out of geographical order")
		return
	if game.DISTRICT_STYLES.size() != game.DISTRICTS.size() or game.traffic_edges.is_empty():
		_fail("District art or road traffic is missing")
		return
	var previous_traffic := -1
	var water_colors := {}
	for index in game.DISTRICTS.size():
		game.district_index = index
		var style: Dictionary = game.DISTRICT_STYLES[index]
		var traffic := int(style["traffic"])
		if traffic <= previous_traffic or water_colors.has(style["water"]):
			_fail("District appearance or road traffic did not change")
			return
		previous_traffic = traffic
		water_colors[style["water"]] = true
		for car in traffic:
			var position: Vector2 = game._traffic_position(car, 17.5)["position"]
			if game.roads.closest_location(position)["point"].distance_to(position) > 0.01:
				_fail("District traffic left the road network")
				return
	game.district_index = 0
	for next_index in range(1, game.DISTRICTS.size()):
		var needed: int = maxi(1, int(ceil(float(game.DISTRICT_THRESHOLDS[next_index] - game.run_earned) / game._income_multiplier())) + 1)
		game._credit(needed)
		if game.unlocked_district_index != next_index or game.district_index != next_index - 1:
			_fail("District %d did not unlock in sequence" % next_index)
			return
		game._activate_district(next_index)
		if game.road_district_index != next_index or game.roads.closest_location(game.player)["point"].distance_to(game.player) > 0.01:
			_fail("District switch did not move the courier onto the new roads")
			return
	var final_needed: int = maxi(1, int(ceil(float(game.REBIRTH_THRESHOLD - game.run_earned) / game._income_multiplier())) + 1)
	game._credit(final_needed)
	game._refresh_ui()
	if game.district_index != game.DISTRICTS.size() - 1 or game.rebirth_button.disabled:
		_fail("Final district or rebirth goal did not unlock")
		return
	var lifetime_before: int = game.total_earned
	game.vehicle = 3
	game.company = true
	for i in 4:
		game.staff_counts[i] = 1
	game.workers = 4
	game.deliveries = 80
	game._rebirth()
	if game.rebirth_count != 1 or game.district_index != 0 or game.unlocked_district_index != 0 or game.album_unlocked.size() != 7 or game.run_earned != 0 or game.money != game.Economy.STARTING_CASH:
		_fail("Rebirth did not reset the current run")
		return
	if game.road_district_index != 0 or game.roads.nodes.size() != game.sile_map["nodes"].size() or game.roads.closest_location(game.player)["point"].distance_to(game.player) > 0.01:
		_fail("Rebirth did not restore the Şile route map")
		return
	if int(game.DISTRICT_STYLES[game.district_index]["traffic"]) != 0:
		_fail("Rebirth did not return to the quiet district appearance")
		return
	if game.vehicle != 0 or game.company or game.workers != 0 or game.staff_counts != [0, 0, 0, 0] or game.deliveries != 0:
		_fail("Vehicles, company or staff survived rebirth")
		return
	if game.total_earned != lifetime_before or game._credit(100) != 125:
		_fail("Lifetime turnover or permanent bonus was lost")
		return
	game._save_game()
	root.remove_child(game)
	game.free()
	var resumed = load("res://scenes/Main.tscn").instantiate()
	root.add_child(resumed)
	if resumed.rebirth_count != 1 or resumed.district_index != 0 or resumed.run_earned != 125 or resumed.total_earned != lifetime_before + 125:
		_fail("Rebirth progress did not survive restart")
		return
	print("District progression passed: visual themes, road traffic, unlocks, rebirth gate, reset, permanent bonus, resume")
	quit(0)

func _fail(reason: String) -> void:
	push_error(reason)
	quit(1)
