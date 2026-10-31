extends RefCounted
# Fixed artwork crop, markers and touch projection; no route or economy state.
var game: Control
func _init(owner: Control) -> void:
	game=owner
func location_position(index: int) -> Vector2:
	var area: Rect2 = game._map_rect()
	var artwork: Texture2D = game._static_map_texture()
	var positions: Array = game._map_location_positions()
	var source: Rect2 = game._static_map_source()
	var image_point: Vector2 = positions[index] * artwork.get_size()
	var screen := area.position + (image_point - source.position) / source.size * area.size
	var safe := area.grow(-24.0)
	return screen.clamp(safe.position, safe.end)


func source_rect() -> Rect2:
	var area: Rect2 = game._map_rect()
	var artwork: Texture2D = game._static_map_texture()
	var image_size := artwork.get_size()
	var view_ratio := area.size.x / area.size.y
	var image_ratio := image_size.x / image_size.y
	var source: Rect2 = Rect2(Vector2.ZERO, image_size)
	if image_ratio < view_ratio:
		source.size.y = image_size.x / view_ratio
		source.position.y = (image_size.y - source.size.y) * 0.5
		if game.district_index in [1, 2]:
			source.position.y = minf(source.position.y, image_size.y * 0.07)
		elif game.district_index == 3:
			source.position.y = minf(source.position.y, image_size.y * 0.025)
		elif game.district_index == 4:
			source.position.y = minf(source.position.y, image_size.y * 0.12)
		elif game.district_index == 5:
			source.position.y = minf(source.position.y, image_size.y * 0.04)
		elif game.district_index == 6:
			source.position.y = minf(source.position.y, image_size.y * 0.02)
	else:
		source.size.x = image_size.y * view_ratio
		source.position.x = (image_size.x - source.size.x) * 0.5
	return source


func draw() -> void:
	game.draw_texture_rect_region(game._static_map_texture(), game._map_rect(), game._static_map_source())
	for i in game.LOCATION_POSITIONS.size():
		var is_shop: bool = i < game.PICKUPS.size()
		var is_pickup: bool = is_shop and i == game.pickup_index
		var is_drop: bool = not is_shop and i - game.PICKUPS.size() == game.drop_index
		var job: Dictionary = game._focus_job()
		var is_target: bool = not job.is_empty() and int(job.get("district", game.district_index)) == game.district_index and ((is_pickup and not game.carrying) or (is_drop and game.carrying))
		var center: Vector2 = game._location_screen_position(i)
		var frame: StyleBox = game.location_style
		if is_pickup:
			frame = game.pickup_location_style
		elif is_drop:
			frame = game.drop_location_style
		if is_target:
			frame = (game.active_location_glow if is_shop else game.drop_location_glow) if game.last_map_animation_frame % 2 == 0 else frame
		var box := Rect2(center - Vector2(18, 18), Vector2(36, 36))
		if i == game.selected_location or is_target: game.draw_style_box(frame, box)
		if i == game.selected_location:
			game.draw_rect(box.grow(3.0), Color("fff0d1"), false, 2.0)
		var icon: Texture2D = game.SHOP_PIXELS[i] if is_shop else game.HOME_PIXELS[i - game.PICKUPS.size()]
		game.draw_texture_rect(icon, Rect2(center - Vector2(12, 12), Vector2(24, 24)), false)


