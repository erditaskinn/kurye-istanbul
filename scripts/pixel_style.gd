@tool
extends StyleBox
@export var fill := Color("102d3e")
@export var outline := Color("477181")
@export var shadow := true
@export var bevel := true
func _get_minimum_size() -> Vector2:
	return Vector2(12, 12)
func stepped(item: RID, area: Rect2, color: Color, cut: float) -> void:
	RenderingServer.canvas_item_add_rect(item, Rect2(area.position + Vector2(cut, 0), Vector2(maxf(0, area.size.x - cut * 2), area.size.y)), color)
	RenderingServer.canvas_item_add_rect(item, Rect2(area.position + Vector2(0, cut), Vector2(area.size.x, maxf(0, area.size.y - cut * 2))), color)
func _draw(item: RID, area: Rect2) -> void:
	var rect := Rect2(area.position.round(), area.size.round())
	if shadow: stepped(item, Rect2(rect.position + Vector2(0, 3), rect.size), Color("03121d"), 4)
	stepped(item, rect, outline.darkened(0.4), 4)
	stepped(item, rect.grow(-1), outline, 3)
	stepped(item, rect.grow(-3), fill, 1)
	if bevel and rect.size.y >= 20:
		RenderingServer.canvas_item_add_rect(item, Rect2(rect.position + Vector2(5, 3), Vector2(maxf(0, rect.size.x - 10), 2)), fill.lightened(0.22))
		RenderingServer.canvas_item_add_rect(item, Rect2(rect.position + Vector2(3, 5), Vector2(2, maxf(0, rect.size.y - 10))), fill.lightened(0.13))
		RenderingServer.canvas_item_add_rect(item, Rect2(rect.position + Vector2(5, rect.size.y - 5), Vector2(maxf(0, rect.size.x - 10), 2)), fill.darkened(0.3))
