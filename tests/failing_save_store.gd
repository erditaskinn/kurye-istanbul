extends "res://scripts/save_store.gd"
# Inject a storage failure before any file mutation, only in the prestige test.
func write_record(_path: String, _data: Dictionary) -> bool:
	return false
