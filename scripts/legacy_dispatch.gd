extends RefCounted

# Company couriers take actual orders from a bounded queue. The same clock is
# advanced while the app runs and when it resumes after time away.
const DEMAND_PER_MINUTE := [1.0, 2.0, 3.0, 5.0, 7.0, 9.0, 12.0]
const ROLE_SPEED := [4.0, 6.5, 10.0, 14.0]
const MAX_QUEUE := 30

var pending: Array[Dictionary] = []
var active: Array[Dictionary] = []
var arrival_elapsed := 0.0
var completed := 0
var missed := 0
var staff_locations: Dictionary = {}

func advance(delta: float, staff_counts: Array[int], district: int, make_order: Callable) -> Array[Dictionary]:
	var finished: Array[Dictionary] = []
	if delta <= 0.0:
		return finished
	_assign(staff_counts, district)
	for i in range(active.size() - 1, -1, -1):
		active[i]["remaining"] = float(active[i]["remaining"]) - delta
		if active[i]["remaining"] <= 0.0:
			staff_locations[_staff_key(int(active[i]["role"]), int(active[i]["slot"]))] = int(active[i]["drop"])
			finished.append(active[i])
			active.remove_at(i)
			completed += 1
	arrival_elapsed += delta
	var interval: float = 60.0 / DEMAND_PER_MINUTE[clampi(district, 0, DEMAND_PER_MINUTE.size() - 1)]
	while arrival_elapsed >= interval:
		arrival_elapsed -= interval
		if pending.size() < MAX_QUEUE:
			pending.append(make_order.call())
		else:
			missed += 1
	_assign(staff_counts, district)
	return finished

func _assign(staff_counts: Array[int], district: int) -> void:
	# Fast vehicles take new work first so buying one changes throughput at once.
	for role in range(ROLE_SPEED.size() - 1, -1, -1):
		var working := 0
		for job in active:
			if job["role"] == role:
				working += 1
		while working < staff_counts[role] and not pending.is_empty():
			var job: Dictionary = pending.pop_front()
			var slot := _free_slot(role, staff_counts[role])
			job["role"] = role
			job["slot"] = slot
			job["origin"] = int(staff_locations.get(_staff_key(role, slot), -1))
			job["duration"] = delivery_seconds(role, district, float(job["distance"]))
			job["remaining"] = job["duration"]
			active.append(job)
			working += 1

func _staff_key(role: int, slot: int) -> String:
	return "%d:%d" % [role, slot]

func _free_slot(role: int, count: int) -> int:
	for slot in count:
		var occupied := false
		for job in active:
			if int(job["role"]) == role and int(job["slot"]) == slot:
				occupied = true
				break
		if not occupied:
			return slot
	return count

func delivery_seconds(role: int, district: int, distance: float) -> float:
	return 20.0 + distance / ROLE_SPEED[role] * (1.0 + district * 0.08)

func reset() -> void:
	pending.clear()
	active.clear()
	arrival_elapsed = 0.0
	completed = 0
	missed = 0
	staff_locations.clear()

func to_save() -> Dictionary:
	return {"pending": pending, "active": active, "staff_locations": staff_locations, "arrival_elapsed": arrival_elapsed, "completed": completed, "missed": missed}

func restore(data: Variant) -> void:
	reset()
	if not data is Dictionary:
		return
	var saved_locations = data.get("staff_locations", {})
	if saved_locations is Dictionary:
		for key in saved_locations:
			staff_locations[str(key)] = int(saved_locations[key])
	for raw in data.get("pending", []):
		if raw is Dictionary and raw.has("distance") and raw.has("payout") and pending.size() < MAX_QUEUE:
			pending.append(raw.duplicate())
	for raw in data.get("active", []):
		if raw is Dictionary and raw.has("distance") and raw.has("payout") and raw.has("remaining") and raw.has("role"):
			var role := int(raw["role"])
			if role >= 0 and role < ROLE_SPEED.size():
				var job: Dictionary = raw.duplicate()
				job["slot"] = int(job.get("slot", _free_slot(role, active.size() + 1)))
				job["origin"] = int(job.get("origin", -1))
				job["duration"] = maxf(maxf(float(job.get("duration", job["remaining"])), float(job["remaining"])), 0.001)
				active.append(job)
	arrival_elapsed = maxf(0.0, float(data.get("arrival_elapsed", 0.0)))
	completed = maxi(0, int(data.get("completed", 0)))
	missed = maxi(0, int(data.get("missed", 0)))
