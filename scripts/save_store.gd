extends RefCounted

const VERSION := 11
var writable := true

func _read(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(path)) != OK or not parser.data is Dictionary:
		return {}
	var data: Dictionary = parser.data
	if not data.has("money") or not data.has("last_saved_at"):
		return {}
	return data

func load_record(path: String) -> Dictionary:
	var data := _read(path)
	if data.is_empty():
		data = _read(path + ".bak")
	if data.is_empty():
		return {}
	if int(data.get("save_version", 0)) > VERSION or int(data.get("economy_version", 0)) > 7:
		writable = false
		push_error("Save belongs to a newer game version; writing disabled")
		return {}
	if int(data.get("save_version", 0)) == 0:
		# Preserve the legacy record, including fields not used by this build.
		data["save_version"] = VERSION
		data["economy_version"] = 0
	return data

func write_record(path: String, data: Dictionary) -> bool:
	if not writable:
		return false
	var record := data.duplicate(true)
	record["save_version"] = VERSION
	record["economy_version"] = int(data.get("economy_version", 0))
	var temp := path + ".tmp"
	var file := FileAccess.open(temp, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(record))
	file.flush()
	var error := file.get_error()
	file.close()
	if error != OK or _read(temp).is_empty():
		return false
	# Never replace a good backup with a corrupt primary.
	if not _read(path).is_empty():
		if DirAccess.rename_absolute(path, path + ".bak") != OK:
			return false
	return DirAccess.rename_absolute(temp, path) == OK
