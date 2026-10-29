extends SceneTree
var font := FontFile.new()
var board := Control.new()
func _initialize() -> void:
	call_deferred("capture")
func label_at(text: String, pos: Vector2, box: Vector2, font_size: int, color: Color) -> void:
	var label := Label.new()
	label.position = pos
	label.size = box
	label.text = text
	label.add_theme_font_override("font",font)
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",color)
	board.add_child(label)
func panel(key: String, pos: Vector2, box: Vector2) -> void:
	var image := Image.load_from_file(ProjectSettings.globalize_path("res://build/design-reviews/header-v2/" + key + ".png"))
	var atlas := AtlasTexture.new()
	atlas.atlas = ImageTexture.create_from_image(image)
	atlas.region = image.get_used_rect()
	var rect := TextureRect.new()
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.texture = atlas
	rect.position = pos
	rect.size = box
	board.add_child(rect)
func capture() -> void:
	font.load_dynamic_font(ProjectSettings.globalize_path("res://build/design-reviews/header-v2/Tiny5.ttf"))
	font.antialiasing = TextServer.FONT_ANTIALIASING_NONE
	font.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED
	for code in [199,231,286,287,304,305,214,246,350,351,220,252,8378]:
		assert(font.has_char(code), "Missing Turkish/lira glyph")
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.content_scale_size = Vector2i.ZERO
	root.size = Vector2i(480,180)
	root.add_child(board)
	board.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var bg := ColorRect.new()
	bg.color = Color("071d2c")
	bg.size = Vector2(480,180)
	board.add_child(bg)
	label_at("MARTI KURYE", Vector2(10,3), Vector2(310,38), 28, Color("ffcf71"))
	panel("district", Vector2(338,2), Vector2(134,40))
	label_at("Şile", Vector2(383,7), Vector2(60,29), 24, Color("fff0d1"))
	for i in 3:
		var x := 8+i*158
		panel(["cash","revenue","deliveries"][i],Vector2(x,46),Vector2(148,60))
		label_at(["KASA","CİRO","TESLİMAT"][i],Vector2(x+52,51),Vector2(90,19),16,Color("fff0d1"))
		label_at(["12,5K ₺","48,2K ₺","1,2K"][i],Vector2(x+52,72),Vector2(90,27),24,Color("70dfcf"))
	label_at("Tiny5 • Türkçe karakter ve para işareti",Vector2(10,119),Vector2(460,24),18,Color("fff0d1"))
	label_at("Çç Ğğ İı Öö Şş Üü   0123456789   ₺",Vector2(10,145),Vector2(460,26),24,Color("70dfcf"))
	await screen("header-preview-native.png")
	root.size = Vector2i(960,360)
	board.scale = Vector2(2,2)
	await screen("header-preview-2x.png")
	print("Header V2 preview captured; Turkish and lira glyphs verified")
	quit()
func screen(filename: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/design-reviews/header-v2/"+filename)
