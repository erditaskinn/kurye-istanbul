extends RefCounted

# Shared event clock. Role 4 is the founder; roles 0..3 are staff.
const Economy = preload("res://scripts/economy.gd")
const DEMAND_PER_MINUTE = Economy.DEMAND_PER_MINUTE
const ROLE_SPEED = Economy.ROLE_SPEED
const MAX_QUEUE := 30
const FOUNDER := 4
const EPS := 0.0000001
var pending: Array[Dictionary] = []
var active: Array[Dictionary] = []
var arrival_elapsed := 0.0
var completed := 0
var founder_completed := 0
var missed := 0
var cursor := 0
var staff_locations: Dictionary = {}

func advance(delta: float, counts: Array[int], district: int, make_order: Callable, founder_vehicle: int = -1, on_complete: Callable = Callable(), current_district: Callable = Callable(), demand_override: Array = [], on_advance: Callable = Callable()) -> Array[Dictionary]:
	var finished: Array[Dictionary] = []
	var remaining := maxf(0.0, delta)
	_assign(counts, district, founder_vehicle)
	while remaining > EPS:
		var region := int(current_district.call()) if current_district.is_valid() else district
		var demand := DEMAND_PER_MINUTE if demand_override.is_empty() else demand_override
		var interval: float = 60.0 / float(demand[clampi(region, 0, 6)])
		var step := minf(remaining, maxf(0.0, interval - arrival_elapsed))
		for job in active:
			step = minf(step, maxf(0.0, float(job["remaining"])))
		for job in active:
			job["remaining"] = maxf(0.0, float(job["remaining"]) - step)
		arrival_elapsed += step
		remaining -= step
		if on_advance.is_valid(): on_advance.call(step)
		var ended: Array[Dictionary] = []
		for job in active:
			if float(job["remaining"]) <= EPS:
				ended.append(job)
		for job in ended:
			active.erase(job)
			staff_locations[_staff_key(int(job["role"]), int(job["slot"]))] = int(job["drop"])
			if int(job["role"]) == FOUNDER:
				founder_completed += 1
			else:
				completed += 1
			finished.append(job)
			if on_complete.is_valid():
				on_complete.call(job)
		region = int(current_district.call()) if current_district.is_valid() else district
		interval = 60.0 / float(demand[clampi(region, 0, 6)])
		while arrival_elapsed + EPS >= interval:
			arrival_elapsed = maxf(0.0, arrival_elapsed - interval)
			if pending.size() < MAX_QUEUE:
				pending.append(make_order.call())
			else:
				missed += 1
		_assign(counts, region, founder_vehicle)
	return finished

func _assign(counts: Array[int], district: int, founder_vehicle: int) -> void:
	var slots: Array[Vector2i] = []
	if founder_vehicle >= 0:
		slots.append(Vector2i(FOUNDER, 0))
	for role in counts.size():
		for slot in counts[role]:
			slots.append(Vector2i(role, slot))
	if slots.is_empty():
		return
	while not pending.is_empty():
		var found := false
		for offset in slots.size():
			var index := (cursor + offset) % slots.size()
			var candidate := slots[index]
			var busy := false
			for job in active:
				if int(job["role"]) == candidate.x and int(job["slot"]) == candidate.y:
					busy = true
					break
			if busy:
				continue
			var job: Dictionary = pending.pop_front()
			job["role"] = candidate.x
			job["slot"] = candidate.y
			job["origin"] = int(staff_locations.get(_staff_key(candidate.x, candidate.y), -1))
			var vehicle := founder_vehicle if candidate.x == FOUNDER else candidate.x
			var speeds: Array = job.get("speed_profile", Economy.LEGACY_ROLE_SPEED)
			var travel := float(job.get("work_distance", job["distance"])) / float(speeds[vehicle]) * (1.0 + int(job.get("district", district)) * 0.08)
			job["duration"] = maxf(0.01, float(job.get("handoff_seconds", 20.0)) + travel)
			job["pickup_seconds"] = float(job["duration"]) * float(job["pickup_share"]) if job.has("pickup_share") else 20.0
			job["remaining"] = job["duration"]
			cursor = (index + 1) % slots.size()
			active.append(job)
			found = true
			break
		if not found:
			break

func delivery_seconds(role: int, district: int, distance: float) -> float:
	return distance / ROLE_SPEED[clampi(role, 0, 3)] * (1.0 + district * 0.08)

func _staff_key(role: int, slot: int) -> String:
	return "%d:%d" % [role, slot]

func founder_job() -> Dictionary:
	for job in active:
		if int(job["role"]) == FOUNDER:
			return job
	return {}

func team_active_count() -> int:
	return active.size() - int(not founder_job().is_empty())

func reset() -> void:
	pending.clear()
	active.clear()
	arrival_elapsed = 0.0
	completed = 0
	founder_completed = 0
	missed = 0
	cursor = 0
	staff_locations.clear()

func to_save() -> Dictionary:
	return {"pending": pending, "active": active, "staff_locations": staff_locations, "arrival_elapsed": arrival_elapsed, "completed": completed, "founder_completed": founder_completed, "missed": missed, "cursor": cursor}

func restore(data: Variant) -> void:
	reset()
	if not data is Dictionary:
		return
	for raw in data.get("pending", []):
		if raw is Dictionary and raw.has("distance") and raw.has("payout") and pending.size() < MAX_QUEUE:
			pending.append(raw.duplicate(true))
	var occupied := {}
	for raw in data.get("active", []):
		if not raw is Dictionary or not raw.has("remaining") or not raw.has("distance") or not raw.has("payout"):
			continue
		var role := int(raw.get("role", -1))
		var slot := int(raw.get("slot", 0))
		var key := _staff_key(role, slot)
		if role < 0 or role > FOUNDER or slot < 0 or occupied.has(key):
			continue
		occupied[key] = true
		var job: Dictionary = raw.duplicate(true)
		job["role"] = role
		job["slot"] = slot
		job["duration"] = maxf(0.001, float(job.get("duration", job["remaining"])))
		job["remaining"] = clampf(float(job["remaining"]), 0.0, job["duration"])
		job["pickup_seconds"] = float(job.get("pickup_seconds", 20.0))
		active.append(job)
	var locations = data.get("staff_locations", {})
	if locations is Dictionary:
		staff_locations = locations.duplicate()
	arrival_elapsed = maxf(0.0, float(data.get("arrival_elapsed", 0.0)))
	completed = maxi(0, int(data.get("completed", 0)))
	founder_completed = maxi(0, int(data.get("founder_completed", 0)))
	missed = maxi(0, int(data.get("missed", 0)))
	cursor = maxi(0, int(data.get("cursor", 0)))
