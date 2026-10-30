extends AcceptDialog
var game: Control
var rows: Array[Button] = []
func build(owner_game: Control) -> void:
	game = owner_game
	title = "Yeni turun uzmanlığı"
	borderless = true
	theme = game.UI_THEME
	add_theme_stylebox_override("panel", game._button_style(Color("071d2c"), Color("f9b553")))
	ok_button_text = "İTİBAR ÖNİZLEMESİNE DÖN"
	get_ok_button().custom_minimum_size.y = 44
	get_label().hide()
	var body := Control.new()
	body.custom_minimum_size = Vector2(408, 522)
	add_child(body)
	game._label(Vector2(8, 4), Vector2(392, 28), 21, Color("ffcf71"), body).text = "YENİ TURUN ÇALIŞMA MODELİ"
	var note: Label = game._label(Vector2(8, 34), Vector2(392, 38), 12, Color("b1c9c9"), body)
	note.text = "Yeni turda hangi ekibin hızlanacağını seç.\nSeçtikten sonra onay ekranına döneceksin."
	for index in 4:
		var panel: Panel = game.FRAMED_PANEL.instantiate()
		panel.position = Vector2(4, 82 + index * 106); panel.size = Vector2(400, 100); body.add_child(panel)
		var icon := TextureRect.new(); icon.position = Vector2(10, 16); icon.size = Vector2(48, 48)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if index == 0: icon.texture = preload("res://assets/ui/progression/trophy.svg")
		else:
			var atlas := AtlasTexture.new(); atlas.atlas = game.STAFF_PORTRAITS
			atlas.region = game.STAFF_PORTRAIT_REGIONS[index]; icon.texture = atlas
		panel.add_child(icon)
		game._label(Vector2(68, 7), Vector2(226, 24), 17, Color("ffcf71"), panel).text = game.Specialization.TITLES[index]
		var detail: Label = game._label(Vector2(68, 34), Vector2(230, 56), 12, Color("d7e4dd"), panel)
		detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		detail.text = game.Specialization.DETAILS[index] + "\n" + ["Ekibinde bir değişiklik olmaz.", "Yaya ve bisiklet ağırlıklı ekipler için.", "Motor ağırlıklı ekipler için.", "Araba ağırlıklı ekipler için."][index]
		var button: Button = game._button(Vector2(306, 24), Vector2(84, 48), choose.bind(index), panel)
		button.add_theme_font_size_override("font_size", 13); rows.append(button)
func open() -> void:
	for index in 4: rows[index].text = "SEÇİLİ" if game.specialization_choice.selected == index else "SEÇ"
	popup_centered(Vector2i(432, 590))
func choose(index: int) -> void:
	game._select_specialization(index)
	hide()
