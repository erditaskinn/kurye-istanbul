extends "res://build/r2/baseline-main-0.18.gd"
var checkpoint_requests := 0
func _load_game() -> void:
	pass
func _save_game() -> void:
	checkpoint_requests += 1
	last_saved_at = maxi(last_saved_at, int(Time.get_unix_time_from_system()))
