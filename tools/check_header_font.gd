extends SceneTree
func _initialize() -> void:
	var font := FontFile.new()
	var result := font.load_dynamic_font(ProjectSettings.globalize_path("res://build/design-reviews/header-v2/Tiny5.ttf"))
	print("Font load: ", result)
	for code in [199,231,286,287,304,305,214,246,350,351,220,252,8378]:
		print(code, ": ",font.has_char(code))
	quit()

