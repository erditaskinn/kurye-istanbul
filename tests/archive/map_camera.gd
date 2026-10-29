extends SceneTree

func _initialize() -> void:
	call_deferred("run_check")

func run_check() -> void:
	var game = load("res://scenes/Main.tscn").instantiate()
	root.add_child(game)
	game._start_playing()
	game.set_process(false)
	game.company = false
	game._close_location_card()
	if game.LOCATION_POSITIONS.size() != 16 or game.CITY_LOCATION_POSITIONS.size() != 16:
		_fail("Both map illustrations must expose all sixteen locations")
		return
	var district_textures: Array[Texture2D] = []
	for district in [0, 1, 2, 3, 4, 5, 6]:
		game.district_index = district
		var artwork: Texture2D = game._static_map_texture()
		if artwork in district_textures:
			_fail("Each district must have a distinct illustration")
			return
		district_textures.append(artwork)
		for height in [800, 1040]:
			root.size = Vector2i(480, height)
			await process_frame
			game._layout_ui()
			if absf(game._bottom_top() - (game.size.y - game.BOTTOM_HEIGHT)) > 0.1:
				_fail("The delivery panel did not follow the phone height")
				return
			if height == 1040 and (game.size.y < 1000 or game._map_rect().size.y < 650):
				_fail("The static map did not expand on a tall phone")
				return
			var targets: Array[Rect2] = []
			if game._map_location_positions().size() != 16:
				_fail("Every district must expose sixteen markers")
				return
			for i in game.LOCATION_POSITIONS.size():
				var center: Vector2 = game._location_screen_position(i)
				var target := Rect2(center - Vector2(22, 22), Vector2(44, 44))
				if not game._map_rect().encloses(target):
					_fail("A location touch target extends outside district %d at height %d" % [district, height])
					return
				for earlier in targets:
					if target.intersects(earlier):
						_fail("Location touch targets overlap in district %d at height %d" % [district, height])
						return
				if district in [1, 2, 3, 4, 5, 6] and target.intersects(Rect2(12, 121, game.size.x - 24, 33)):
					_fail("District %d marker %d at height %d is behind the team HUD" % [district, i, height])
					return
				targets.append(target)
	game.district_index = 0
	game._build_roads()
	game.player = game._district_spawn()
	game.pickup_index = 1
	game.drop_index = 2
	game.carrying = false
	game.dispatch.reset()
	game._seed_founder_job()
	game._route_to_mission()
	root.size = Vector2i(480, 800)
	await process_frame
	game._layout_ui()
	var marker: Vector2 = game._location_screen_position(1)
	game.camera_center = Vector2(300, 500)
	game.camera_zoom = 3.0
	game._process(0.1)
	if game._location_screen_position(1) != marker:
		_fail("The map marker moved while the delivery simulation ran")
		return
	var original_route: Array[Vector2] = game.waypoints.duplicate()
	_tap(game, 1)
	if game.selected_location != 1 or not game.location_panel.visible or game.waypoints != original_route:
		_fail("Inspecting a shop must open its card without changing the delivery route")
		return
	if game.location_name_label.text != game.PICKUPS[1]["name"] or not game.location_type_label.text.begins_with("DÜKKÂN") or not game.location_role_label.text.contains("alım noktası") or not game.location_role_label.text.contains("Sıradaki durak"):
		_fail("The current pickup card has the wrong name, type or order role")
		return
	if game._map_input_allowed(game.location_panel.get_rect().get_center()):
		_fail("Touches on the information card can pass through to the map")
		return
	game._advance_simulation(20.0)
	game._refresh_ui()
	if not game.carrying or game.selected_location != 1 or not game.location_role_label.text.contains("Paket alındı"):
		_fail("The open pickup card did not update when its package was collected")
		return
	game._close_location_card()
	_tap(game, game.PICKUPS.size() + 2)
	if game.location_name_label.text != game.DROPS[2]["name"] or not game.location_type_label.text.begins_with("EV") or not game.location_role_label.text.contains("teslimat noktası") or not game.location_role_label.text.contains("Sıradaki durak"):
		_fail("The delivery address card has the wrong name, type or order role")
		return
	var founder: Dictionary = game.dispatch.founder_job()
	founder["remaining"] = founder["duration"]
	game._refresh_ui()
	if not game.location_role_label.text.contains("Alımdan sonra"):
		_fail("The open delivery card did not refresh its phase-dependent role")
		return
	game._close_location_card()
	_tap(game, 0)
	if game.location_name_label.text != game.PICKUPS[0]["name"] or not game.location_role_label.text.contains("Sipariş noktası"):
		_fail("A shop outside the active order is incorrectly marked as its pickup")
		return
	for index in [1, game.PICKUPS.size() + 2]:
		game._close_location_card()
		var route_before_inspection: Array[Vector2] = game.waypoints.duplicate()
		_tap(game, index)
		if game.waypoints != route_before_inspection or not game.location_panel.visible:
			_fail("Shop and home cards must preserve automatic delivery routing")
			return
		for child in game.location_panel.get_children():
			if child is Button and child.text != "×":
				_fail("Information cards must not offer manual route actions")
				return
	game._close_location_card()
	var selected_route: Array[Vector2] = game.waypoints.duplicate()
	var drag_start: Vector2 = game._location_screen_position(1)
	_touch(game, 0, drag_start, true)
	var drag := InputEventScreenDrag.new()
	drag.index = 0
	drag.position = drag_start + Vector2(30, 0)
	game._gui_input(drag)
	_touch(game, 0, drag.position, false)
	if game.selected_location != -1 or game.location_panel.visible or game.waypoints != selected_route:
		_fail("Dragging over a marker opened its card or changed the route")
		return
	_touch(game, 0, drag_start, true)
	_touch(game, 1, game._location_screen_position(2), true)
	_touch(game, 0, drag_start, false)
	_touch(game, 1, game._location_screen_position(2), false)
	_touch(game, 0, drag_start, true)
	_touch(game, 0, drag_start, false, true)
	if game.selected_location != -1 or game.location_panel.visible or game.waypoints != selected_route or not game.touch_starts.is_empty():
		_fail("A multi-touch or canceled gesture selected a location or left an active touch")
		return
	for modal in [game.menu_overlay, game.settings_overlay, game.company_panel, game.district_panel, game.reset_dialog, game.rebirth_dialog]:
		_tap(game, 1)
		modal.visible = true
		_tap(game, 2)
		if game.selected_location != 1 or game.waypoints != selected_route or game._select_map_location(game._location_screen_position(3)):
			_fail("A modal allowed location selection or route changes behind it")
			return
		modal.visible = false
		game._close_location_card()
	print("Static map passed: seven distinct district illustrations, phone layouts, location cards, phase updates, automatic route preservation, gestures and modal blocking")
	quit(0)

func _tap(game: Control, index: int) -> void:
	var point: Vector2 = game._location_screen_position(index)
	_touch(game, 0, point, true)
	_touch(game, 0, point, false)

func _touch(game: Control, index: int, point: Vector2, pressed: bool, canceled: bool = false) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = point
	event.pressed = pressed
	event.canceled = canceled
	game._gui_input(event)

func _fail(reason: String) -> void:
	push_error(reason)
	quit(1)
