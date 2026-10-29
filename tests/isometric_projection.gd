extends SceneTree

const IsoProjection = preload("res://scripts/isometric_projection.gd")

func _initialize() -> void:
	for point in [Vector2.ZERO, Vector2(62, 338), Vector2(230, 502), Vector2(-90, 800)]:
		if IsoProjection.unproject(IsoProjection.project(point)).distance_to(point) > 0.001:
			push_error("Isometric projection did not preserve map coordinates")
			quit(1)
			return
	var east := IsoProjection.project(Vector2.RIGHT)
	var south := IsoProjection.project(Vector2.DOWN)
	if east != Vector2(1, 0.5) or south != Vector2(-1, 0.5):
		push_error("Isometric axes are not a 2:1 diamond")
		quit(1)
		return
	print("Isometric projection passed: map coordinates and diamond axes")
	quit(0)
