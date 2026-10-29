extends RefCounted
# Bounded, on-device playtest data. No account, device identifier or network access.
const LIMIT := 128
const NAMES := ["visit", "automation_started", "investment", "team_unlocked", "first_staff", "district_unlocked", "district_selected", "offline_return", "prestige"]
var events: Array[Dictionary] = []
var counts: Dictionary = {}
var firsts: Dictionary = {}
var run_flags: Dictionary = {}
var sequence := 0
var visit := 0
var total_seconds := 0.0
var run_seconds := 0.0
var coverage := "new_game"

func advance(seconds: float) -> void:
	var amount := maxf(0.0, seconds)
	total_seconds += amount
	run_seconds += amount

func record(name: String, values: Dictionary = {}, once_per_run: bool = false) -> void:
	if not NAMES.has(name) or (once_per_run and run_flags.has(name)): return
	if once_per_run: run_flags[name] = true
	sequence += 1
	var row := {"event": name, "sequence": sequence, "visit": visit, "unix_seconds": int(Time.get_unix_time_from_system()), "total_simulation_seconds": total_seconds, "run_simulation_seconds": run_seconds, "values": values.duplicate(true)}
	events.append(row)
	if events.size() > LIMIT: events.pop_front()
	counts[name] = int(counts.get(name, 0)) + 1
	if not firsts.has(name): firsts[name] = row.duplicate(true)

func begin_visit() -> void:
	visit += 1
	record("visit")

func next_run() -> void:
	run_seconds = 0.0
	run_flags.clear()

func to_save() -> Dictionary:
	return {"events": events.duplicate(true), "counts": counts.duplicate(true), "firsts": firsts.duplicate(true), "run_flags": run_flags.duplicate(true), "sequence": sequence, "visit": visit, "total_seconds": total_seconds, "run_seconds": run_seconds, "coverage": coverage}

func restore(data: Variant) -> void:
	events.clear()
	counts.clear()
	firsts.clear()
	run_flags.clear()
	sequence = 0
	visit = 0
	total_seconds = 0.0
	run_seconds = 0.0
	coverage = "since_upgrade"
	if not data is Dictionary: return
	coverage = "new_game" if str(data.get("coverage", "")) == "new_game" else "since_upgrade"
	sequence = maxi(0, int(data.get("sequence", 0)))
	visit = maxi(0, int(data.get("visit", 0)))
	total_seconds = maxf(0.0, float(data.get("total_seconds", 0)))
	run_seconds = maxf(0.0, float(data.get("run_seconds", 0)))
	var saved_events = data.get("events", [])
	if saved_events is Array:
		for i in range(maxi(0, saved_events.size() - LIMIT), saved_events.size()):
			var row = saved_events[i]
			if row is Dictionary and NAMES.has(str(row.get("event", ""))): events.append(row.duplicate(true))
	for name in NAMES:
		var saved_counts = data.get("counts", {})
		if saved_counts is Dictionary and saved_counts.has(name): counts[name] = maxi(0, int(saved_counts[name]))
		var saved_firsts = data.get("firsts", {})
		if saved_firsts is Dictionary and saved_firsts.get(name) is Dictionary: firsts[name] = saved_firsts[name].duplicate(true)
		var saved_flags = data.get("run_flags", {})
		if saved_flags is Dictionary and bool(saved_flags.get(name, false)): run_flags[name] = true
