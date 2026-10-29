extends RefCounted
## Projection between the road simulation's flat coordinates and the
## screen-facing, 2:1 diamond layout. Sprites must be drawn upright at the
## projected position rather than transformed with the ground.

static func project(point: Vector2) -> Vector2:
	return Vector2(point.x - point.y, (point.x + point.y) * 0.5)

static func unproject(point: Vector2) -> Vector2:
	return Vector2(point.y + point.x * 0.5, point.y - point.x * 0.5)
