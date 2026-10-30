extends RefCounted
# Approved HUD presentation only; owns no simulation or save state.
var game: Control
func _init(owner: Control) -> void:
	game=owner
func build() -> void:
	game.header_font = FontVariation.new()
	game.header_font.base_font = ThemeDB.fallback_font
	game.header_font.fallbacks = [game.HEADER_FONT]
	game.theme = game.UI_THEME.duplicate()
	game.theme.default_font = game.header_font
	for texture in game.HEADER_PANELS:
		var tile := AtlasTexture.new()
		tile.atlas = texture
		tile.region = texture.get_image().get_used_rect()
		game.header_panels.append(tile)
	game.title_label = game._label(Vector2(48, 3), Vector2(280, 36), 28, Color("ffcf71"))
	game.title_label.add_theme_font_override("font", game.header_font)
	game.district_button = game._button(Vector2(338, 0), Vector2(134, 44), game._toggle_district_panel)
	game.district_button.add_theme_font_override("font", game.header_font)
	for state in ["normal", "hover", "pressed", "disabled"]:
		var style := StyleBoxTexture.new()
		style.texture = game.header_panels[3]
		style.content_margin_left = 42
		style.content_margin_right = 18
		style.content_margin_top = 0
		style.content_margin_bottom = 0
		if state == "pressed": style.modulate_color = Color(0.8, 0.9, 0.9)
		game.district_button.add_theme_stylebox_override(state, style)
	game.district_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	game.money_label = game._label(Vector2(60, 72), Vector2(90, 27), 24, Color("70dfcf"))
	game.revenue_label = game._label(Vector2(218, 72), Vector2(90, 27), 24, Color("70dfcf"))
	game.deliveries_label = game._label(Vector2(376, 72), Vector2(90, 27), 24, Color("70dfcf"))
	for counter in [game.money_label, game.revenue_label, game.deliveries_label]: counter.add_theme_font_override("font", game.header_font)
	for i in 3:
		var caption: Label = game._label(Vector2(60 + i * 158, 51), Vector2(90, 19), 14, Color("fff0d1"))
		caption.text = ["KASA", "CİRO", "TESLİMAT"][i]
		caption.add_theme_font_override("font", game.header_font)

func refresh() -> void:
	game.title_label.text = game.company_name.to_upper() if game.brand_ready else "İSTANBUL KURYE"
	game.title_label.add_theme_font_size_override("font_size", 28)
	game.title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	game.district_button.text = game.DISTRICTS[game.district_index] + (" +%d" % (game.unlocked_district_index - game.district_index) if game.unlocked_district_index > game.district_index else "")
	game.district_button.tooltip_text = game.district_button.text
	var district_font_size := 24
	while district_font_size > 12 and game.header_font.get_string_size(game.district_button.text, HORIZONTAL_ALIGNMENT_LEFT, -1, district_font_size).x > 72:
		district_font_size -= 1
	game.district_button.add_theme_font_size_override("font_size", district_font_size)
	game.money_label.text = "%s ₺" % game.Numbers.compact(game.money)
	game.revenue_label.text = "%s ₺" % game.Numbers.compact(game.total_earned)
	game.money_label.tooltip_text = game.Numbers.exact(game.money) + " ₺"
	game.revenue_label.tooltip_text = game.Numbers.exact(game.total_earned) + " ₺"
	game.deliveries_label.tooltip_text = game.Numbers.exact(game.deliveries + game.dispatch.completed if game.simulation_economy_version >= 6 else game.deliveries) + " • Bu tur"
	game.deliveries_label.text = "%s" % game.Numbers.compact(game.deliveries + game.dispatch.completed if game.simulation_economy_version >= 6 else game.deliveries)
	for counter in [game.money_label, game.revenue_label, game.deliveries_label]:
		var font: Font = counter.get_theme_font("font")
		var font_size := 20
		while font_size > 12 and font.get_string_size(counter.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > counter.size.x:
			font_size -= 1
		counter.add_theme_font_size_override("font_size", font_size)


func draw() -> void:
	var bottom: float = game._bottom_top()
	game.draw_rect(Rect2(0, 0, game.size.x, game.MAP_TOP), Color("071d2c"))
	game.draw_rect(Rect2(0, game.MAP_TOP - 3, game.size.x, 3), Color("23658b"))
	for i in mini(3, game.header_panels.size()):
		game.draw_texture_rect(game.header_panels[i], Rect2(8 + i * 158, 46, 148, 60), false)
	game.draw_rect(Rect2(0, bottom, game.size.x, game.size.y - bottom), Color("071d2c"))
	game.draw_rect(Rect2(0, bottom, game.size.x, 3), Color("23658b"))
	game.draw_style_box(game.mission_card_style, Rect2(12, bottom + 5, game.size.x - 24, 83))
	game.draw_texture_rect(game.UI_ICONS["package"], Rect2(23, bottom + 18, 28, 28), false)

