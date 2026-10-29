extends "res://build/r4/baseline/isolated-main.gd"
func _load_game() -> void:
	pass
func _save_game() -> void:
	last_saved_at=maxi(last_saved_at,int(Time.get_unix_time_from_system()))
