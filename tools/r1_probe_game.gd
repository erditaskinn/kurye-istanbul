extends "res://scripts/main.gd"
# Measurement-only subclass: real gameplay functions, no player-save loading.
# Purchase checkpoints are counted rather than written during policy sweeps.
# Prestige still exercises its real commit against the isolated APPDATA.
var checkpoint_requests := 0
func _load_game() -> void:
	pass
func _save_game() -> void:
	checkpoint_requests += 1
	last_saved_at = maxi(last_saved_at, int(Time.get_unix_time_from_system()))
