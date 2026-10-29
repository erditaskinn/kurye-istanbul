extends SceneTree

func _initialize() -> void:
	var store = load("res://scripts/save_store.gd").new()
	var path := "user://save-test.json"
	var original := {"money": 1234, "last_saved_at": 100, "staff_counts": [2, 1, 0, 0], "rebirth_count": 3}
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(original))
	file.close()
	var migrated: Dictionary = store.load_record(path)
	assert(migrated["money"] == 1234 and migrated["save_version"] == store.VERSION)
	assert(store.write_record(path, migrated))
	migrated["money"] = 1500
	assert(store.write_record(path, migrated))
	file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string("{broken")
	file.close()
	var recovered: Dictionary = store.load_record(path)
	assert(recovered["money"] == 1234 and int(recovered["staff_counts"][0]) == 2 and int(recovered["staff_counts"][1]) == 1)
	assert(store.write_record(path, recovered))
	assert(store.load_record(path)["rebirth_count"] == 3)
	print("Save store passed: legacy migration, repeated commit, corrupt primary recovery")
	quit()

