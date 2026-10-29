extends RefCounted

# The map art and courier movement use the same vertices and links. A future
# district can replace this graph without changing how routes are followed.
var nodes: Array[Vector2] = []
var links: Array = []
var _astar := AStar2D.new()

func add_node(point: Vector2) -> int:
	nodes.append(point)
	links.append([])
	_astar.add_point(nodes.size() - 1, point)
	return nodes.size() - 1

func connect_nodes(a: int, b: int) -> void:
	assert(a >= 0 and a < nodes.size() and b >= 0 and b < nodes.size() and a != b)
	if not links[a].has(b):
		links[a].append(b)
		links[b].append(a)
		_astar.connect_points(a, b)

func closest_location(point: Vector2) -> Dictionary:
	var best := {"point": Vector2.ZERO, "a": -1, "b": -1}
	var best_distance := INF
	for a in nodes.size():
		for b in links[a]:
			if a >= b:
				continue
			var edge: Vector2 = nodes[b] - nodes[a]
			var fraction := clampf((point - nodes[a]).dot(edge) / edge.length_squared(), 0.0, 1.0)
			var snapped: Vector2 = nodes[a] + edge * fraction
			var distance := point.distance_squared_to(snapped)
			if distance < best_distance:
				best_distance = distance
				best = {"point": snapped, "a": a, "b": b}
	return best

func find_path(start: int, goal: int) -> PackedInt32Array:
	var result := PackedInt32Array()
	for node_id in _astar.get_id_path(start, goal):
		result.append(node_id)
	return result

func route_between(start_point: Vector2, end_point: Vector2) -> Array[Vector2]:
	var start := closest_location(start_point)
	var destination := closest_location(end_point)
	if start["a"] == -1 or destination["a"] == -1:
		return []
	var route: Array[Vector2] = []
	var shortest := INF
	# A direct trip along one edge avoids a detour to its intersection.
	if start["a"] == destination["a"] and start["b"] == destination["b"]:
		shortest = start["point"].distance_to(destination["point"])
		route = [destination["point"]]
	for start_node in [start["a"], start["b"]]:
		for end_node in [destination["a"], destination["b"]]:
			var path := find_path(start_node, end_node)
			if path.is_empty():
				continue
			var length: float = start["point"].distance_to(nodes[start_node]) + nodes[end_node].distance_to(destination["point"])
			for i in range(path.size() - 1):
				length += nodes[path[i]].distance_to(nodes[path[i + 1]])
			if length < shortest:
				shortest = length
				route = [nodes[start_node]]
				for i in range(1, path.size()):
					route.append(nodes[path[i]])
				route.append(destination["point"])
	return route
