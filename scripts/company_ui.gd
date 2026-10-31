extends Control
const LOGOS = [preload("res://assets/ui/company/logo_0.svg"), preload("res://assets/ui/company/logo_1.svg"), preload("res://assets/ui/company/logo_2.svg"), preload("res://assets/ui/company/logo_3.svg"), preload("res://assets/ui/company/logo_4.svg"), preload("res://assets/ui/company/logo_5.svg"), preload("res://assets/ui/company/logo_6.svg"), preload("res://assets/ui/company/logo_7.svg"), preload("res://assets/ui/company/logo_8.svg")]
const LOGO_NAMES := ["Kanat", "Pusula", "Şimşek", "Rota", "Kupa", "Taç", "Paket", "Yıldız", "Filo"]
const NAV_ART = preload("res://assets/ui/navigation/nav-icons-v1.png")
const NAV_NAMES := ["Filo", "Geliştir", "Ekip Motivasyonu", "Şirket", "Ayarlar"]
const NAV_TABS := [4, 0, 1, 2, 3]
const FLEET_ART = preload("res://assets/ui/navigation/fleet-v1.png")
var comparison_buttons: Dictionary = {}
var fleet_ribbon: Panel
var fleet_counts: Array[Label] = []
var company_progress: Label
var requested_tab := -1
var district_tip: Panel
var reward_badge: Label
var motivation_hint: Button
var motivation_bar: ProgressBar
var motivation_balance: Label
var achievement_rows: Dictionary = {}
var motivation_body: Label
var motivation_buy: Button
var nav_normal: Array[AtlasTexture] = []
var nav_pressed: Array[AtlasTexture] = []
var nav_markers: Array[ColorRect] = []
var game: Control
var sheet: Panel
var sheet_title: Label
var content: Control
var sheet_scroll: ScrollContainer
var nav: Array[Button] = []
var cards: Dictionary = {}
var sheet_tab := -1
var flow_note: Label
var income: Label
var activity: Label
var emblem: TextureRect
var creation: ColorRect
var creation_card: Panel
var name_field: LineEdit
var create_button: Button
var logo_buttons: Array[Button] = []
var logo_choice := 0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	income = game._label(Vector2.ZERO, Vector2(388, 30), 22, Color("70dfcf"), self)
	activity = game._label(Vector2.ZERO, Vector2(402, 40), 12, Color("d8e4dd"), self)
	emblem = TextureRect.new()
	emblem.position = Vector2(8, 4)
	emblem.size = Vector2(32, 32)
	emblem.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	emblem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(emblem)
	for i in 5:
		var b: Button = game._button(Vector2.ZERO, Vector2(120, 56), _request_tab.bind(NAV_TABS[i]), self)
		for row in 2:
			var tile := AtlasTexture.new()
			tile.atlas = FLEET_ART if i == 0 else NAV_ART
			tile.region = Rect2(280, 95, 880, 880) if i == 0 else Rect2([68, 494, 918, 1342][i - 1], 56 if row == 0 else 464, 368, 368)
			if row == 0: nav_normal.append(tile)
			else: nav_pressed.append(tile)
		b.text = ""
		b.tooltip_text = NAV_NAMES[i]
		b.icon = nav_normal[i]
		b.expand_icon = true
		b.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		b.add_theme_constant_override("icon_max_width", 52)
		for state in ["normal", "hover", "pressed", "disabled", "hover_pressed"]:
			b.add_theme_stylebox_override(state, _nav_style(i, state in ["pressed", "hover_pressed"], state == "hover"))
		b.button_down.connect(_nav_down.bind(i))
		b.button_up.connect(_refresh_nav)
		var marker := ColorRect.new()
		marker.color = Color("70dfcf")
		marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(marker)
		marker.hide()
		nav_markers.append(marker)
		nav.append(b)
	reward_badge = game._label(Vector2.ZERO, Vector2(24, 20), 12, Color("071d2c"), nav[3])
	reward_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	reward_badge.add_theme_stylebox_override("normal", game._button_style(Color("ffcf71"), Color("fff0d1")))
	reward_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reward_badge.position = Vector2(64, 4)
	sheet = game.FRAMED_PANEL.instantiate()
	sheet.size = Vector2(456, 428)
	add_child(sheet)
	sheet_title = game._label(Vector2(16, 10), Vector2(365, 30), 21, Color("ffcf71"), sheet)
	game._button(Vector2(398, 4), Vector2(44, 44), close_all, sheet).text = "×"
	var scroll := ScrollContainer.new()
	sheet_scroll = scroll
	scroll.position = Vector2(16, 52)
	scroll.size = Vector2(424, 358)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sheet.add_child(scroll)
	content = Control.new()
	content.mouse_filter = Control.MOUSE_FILTER_PASS
	content.custom_minimum_size = Vector2(408, 360)
	scroll.add_child(content)
	sheet.hide()
	district_tip = game.FRAMED_PANEL.instantiate()
	district_tip.position = Vector2(16, game.MAP_TOP + 12)
	district_tip.size = Vector2(448, 108)
	add_child(district_tip)
	var tip: Label = game._label(Vector2(12, 8), Vector2(424, 40), 14, Color("ffcf71"), district_tip)
	tip.text = "Beykoz açıldı!\nİlçeleri karşılaştırıp nerede çalışacağını seç."
	game._button(Vector2(12, 56), Vector2(266, 44), _first_district.bind(true), district_tip).text = "İLÇELERİ GÖR"
	game._button(Vector2(290, 56), Vector2(144, 44), _first_district.bind(false), district_tip).text = "DAHA SONRA"
	district_tip.hide()
	_build_fleet_ribbon()
	_build_creation()
	game.resized.connect(layout)
	layout()
	sync()

func _process(_delta: float) -> void:
	visible = creation.visible or (not game.menu_overlay.visible and not game.settings_overlay.visible and not game.return_overlay.visible)
	for node in nav + [income, activity, emblem]: node.visible = not creation.visible
	fleet_ribbon.visible = game.has_started and not creation.visible and not sheet.visible and not game.district_panel.visible and not district_tip.visible
	district_tip.visible = game.has_started and game.unlocked_district_index >= 1 and not game.district_tip_seen and not blocks_map() and game._map_actions_allowed()

func layout() -> void:
	if nav.is_empty(): return
	var bottom: float = game._bottom_top()
	income.position = Vector2(62, bottom + 10)
	activity.position = Vector2(62, bottom + 43)
	var cell_width: float = game.size.x / 5.0
	for i in 5:
		nav[i].position = Vector2(i * cell_width, game.size.y - 56)
		nav[i].size = Vector2(cell_width, 56)
		nav_markers[i].position = Vector2(12, 52)
		nav_markers[i].size = Vector2(cell_width - 24, 4)
	sheet.position = Vector2(12, maxf(118, game.size.y - 488))
	creation_card.position = (game.size - creation_card.size) * 0.5

func close_all() -> void:
	sheet_tab = -1
	sheet.hide()
	creation.hide()
	_refresh_nav()

func _first_district(show_districts: bool) -> void:
	game.district_tip_seen = true
	district_tip.hide()
	game._save_game()
	if show_districts: _districts()

func _nav_style(index: int, active: bool, hover: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("205965") if active else (Color("102c3d") if hover else Color("071d2c"))
	style.border_color = Color("70dfcf") if active else Color("8c7046")
	style.border_width_top = 4 if active else 2
	style.border_width_left = 2 if index > 0 else 0
	# Keep the icon centered without shrinking the square to fit border margins.
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 2
	style.content_margin_bottom = 2
	return style

func _nav_down(index: int) -> void:
	nav[index].icon = nav_pressed[index]

func _refresh_nav() -> void:
	for i in nav.size():
		var active: bool = NAV_TABS[i] == sheet_tab
		nav[i].icon = nav_pressed[i] if active else nav_normal[i]
		nav[i].add_theme_stylebox_override("normal", _nav_style(i, active))
		nav_markers[i].visible = active

func blocks_map() -> bool:
	return sheet.visible or creation.visible

# Input callbacks finish before the clicked control is removed from the tree.
func _request_tab(index: int) -> void:
	requested_tab = index
	call_deferred("_flush_tab_request")

func _flush_tab_request() -> void:
	if requested_tab < 0: return
	var index := requested_tab
	requested_tab = -1
	open_tab(index)

func _build_fleet_ribbon() -> void:
	fleet_ribbon = game.FRAMED_PANEL.instantiate()
	fleet_ribbon.position = Vector2(12, game.MAP_TOP + 8)
	fleet_ribbon.size = Vector2(456, 38)
	fleet_ribbon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fleet_ribbon)
	for i in 4:
		var portrait := AtlasTexture.new()
		portrait.atlas = game.STAFF_PORTRAITS
		portrait.region = game.STAFF_PORTRAIT_REGIONS[i]
		_art(portrait, Vector2(8 + i * 53, 3), Vector2(28, 30), fleet_ribbon)
		fleet_counts.append(game._label(Vector2(35 + i * 53, 7), Vector2(25, 24), 14, Color("70dfcf"), fleet_ribbon))
	company_progress = game._label(Vector2(228, 7), Vector2(220, 24), 14, Color("ffcf71"), fleet_ribbon)

func _build_comparison() -> void:
	var keys: Array = cards.keys()
	var width := 400.0 / keys.size()
	for i in keys.size():
		var key: String = keys[i]
		var button: Button = game._button(Vector2(2 + i * width, 66), Vector2(width - 4, 80), _focus_card.bind(key), content)
		button.set_meta("base_text_size", 14)
		button.add_theme_font_size_override("font_size", game._text_size(14))
		button.tooltip_text = "Ayrıntıları gör; bu düğme satın almaz."
		comparison_buttons[key] = button

func _focus_card(key: String) -> void:
	if cards.has(key): sheet_scroll.scroll_vertical = int(cards[key]["panel"].position.y)

func _achievement_order() -> Array:
	var ready: Array = []
	var pending: Array = []
	var claimed: Array = []
	for item in game.Achievements.ITEMS:
		if game.achievement_claimed.has(item[0]): claimed.append(item)
		elif game.Achievements.progress(game, item) >= int(item[3]): ready.append(item)
		else: pending.append(item)
	return ready + pending + claimed

func open_tab(index: int) -> void:
	if index == 3:
		close_all()
		game._open_settings()
		return
	if sheet_tab == index and sheet.visible:
		close_all()
		return
	creation.hide()
	game._close_location_card()
	game.district_panel.hide()
	game.guide_panel.hide()
	sheet_tab = index
	sheet_scroll.scroll_vertical = 0
	sheet.show()
	for child in content.get_children():
		content.remove_child(child)
		child.queue_free()
	cards.clear()
	comparison_buttons.clear()
	achievement_rows.clear()
	sheet_title.text = ["GELİŞTİR", "EKİP MOTİVASYONU", "ŞİRKET", "AYARLAR", "FİLO", "BAŞARIMLAR"][index]
	flow_note = game._label(Vector2(8, 0), Vector2(392, 58), 12, Color("b1c9c9"), content)
	flow_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if index == 0:
		_card("service", 66, "Hizmet Kalitesi", "", game._buy_service)
		_card("bonus", 254, "Teslimat Primi", "", game._buy_company_upgrade.bind("bonus"))
		_card("comfort", 442, "Çalışma Konforu", "", game._buy_company_upgrade.bind("comfort"))
		_note(1044, "Hizmet ve prim, yeni teslimatlardan daha çok para kazandırır. Konfor, özellikle yaya ve bisikletli ekibi hızlandırır. Gelir tahminleri aynı ilçe içindir. Bekleyen işler eski ücretle biter; bu bekleme, masrafın çıkma süresine dahil değildir.")
		content.custom_minimum_size.y = 1222
	elif index == 1:
		var panel: Panel = game.FRAMED_PANEL.instantiate()
		panel.mouse_filter = Control.MOUSE_FILTER_PASS
		panel.position = Vector2(2, 68); panel.size = Vector2(400, 80); content.add_child(panel)
		_art(preload("res://assets/ui/progression/star.svg"), Vector2(14, 14), Vector2(54, 54), panel)
		game._label(Vector2(90, 10), Vector2(295, 22), 14, Color("b1c9c9"), panel).text = "MOTİVASYON YILDIZI"
		motivation_balance = game._label(Vector2(90, 32), Vector2(295, 36), 27, Color("ffcf71"), panel)
		motivation_body = game._label(Vector2(12, 160), Vector2(386, 100), 16, Color("d7e4dd"), content)
		motivation_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		motivation_buy = game._button(Vector2(8, 308), Vector2(390, 48), game._buy_motivation, content)
		game._primary_button(motivation_buy)
		motivation_hint = game._button(Vector2(8, 2), Vector2(390, 52), _request_tab.bind(5), content)
		motivation_hint.add_theme_font_size_override("font_size", 13)
		motivation_bar = _progress(Vector2(12, 272), Vector2(380, 20), content)
		_note(376, "100 teslimatta 1 yıldız kazanırsın. Yeni tura geçince 10 yıldız daha alırsın. Başarımlardan da yıldız toplayabilirsin. Bu geliştirme yeni turlarda silinmez. Artış, yeni gelen siparişlerde başlar; bekleyenlerin ücreti değişmez.")
		game._button(Vector2(8, 532), Vector2(390, 46), _request_tab.bind(5), content).text = "BAŞARIMLARI İNCELE ›"
		content.custom_minimum_size.y = 598
	elif index == 5:
		var y := 72
		for item in _achievement_order():
			var panel: Panel = game.FRAMED_PANEL.instantiate()
			panel.mouse_filter = Control.MOUSE_FILTER_PASS
			panel.position = Vector2(2, y); panel.size = Vector2(400, 150); content.add_child(panel)
			_art(preload("res://assets/ui/progression/trophy.svg"), Vector2(12, 14), Vector2(42, 42), panel)
			game._label(Vector2(66, 12), Vector2(320, 26), 18, Color("ffcf71"), panel).text = item[1]
			var detail: Label = game._label(Vector2(14, 64), Vector2(248, 30), 13, Color("d7e4dd"), panel)
			var bar := _progress(Vector2(14, 106), Vector2(240, 18), panel)
			var button: Button = game._button(Vector2(266, 76), Vector2(122, 48), game._claim_achievement.bind(str(item[0])), panel)
			button.add_theme_font_size_override("font_size", 12)
			achievement_rows[str(item[0])] = {"detail": detail, "bar": bar, "button": button}
			y += 162
		_note(y + 8, "Hedefe ulaşınca yıldızını AL düğmesiyle topla. Her ödül yalnız bir kez alınır. Yeni turda başarımların korunur. Ayarlar’dan oyunu sıfırlarsan silinir.")
		content.custom_minimum_size.y = y + 170
	elif index == 4:
		for i in 4: _card("fleet" + str(i), 66 + i * 188, game.STAFF_NAMES[i], "", game._hire_worker.bind(i), i)
		_note(1338, "Yeni kurye, daha çok siparişe yetişmeni sağlar. Ekibin tüm siparişleri zaten yetiştiriyorsa kurye eklemek gelirini artırmayabilir.")
		content.custom_minimum_size.y = 1512
	else:
		var brand: Label = game._label(Vector2(6, 64), Vector2(390, 26), 18, Color("ffcf71"), content)
		brand.text = game.company_name
		brand.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		game._button(Vector2(6, 96), Vector2(390, 44), open_creation, content).text = "ŞİRKET ADI VE LOGOSU"
		_card("operations", 152, "Operasyon Merkezi", "", game._buy_company_upgrade.bind("operations"))
		game._button(Vector2(6, 446), Vector2(390, 44), _districts, content).text = "İLÇELER VE İSTANBUL ALBÜMÜ ›"
		game._button(Vector2(6, 502), Vector2(390, 44), _request_tab.bind(5), content).text = "BAŞARIMLAR VE YILDIZ ÖDÜLLERİ ›"
		_note(560, ("Uzmanlık: " + game.Specialization.TITLES[game.Specialization.IDS.find(game.specialization_id)] + ". Sonraki itibarda ücretsiz seçim. " if game.rebirth_count > 0 else "Uzmanlık ilk İstanbul İtibarı ile açılır. ") + "Gösterilen gelir yaklaşık değerdir. Yeni geliştirmeler, yeni siparişlerde etkili olur. Alamadığın siparişler için kasandan para kesilmez.")
		content.custom_minimum_size.y = 740
	if index in [0, 4]: _build_comparison()
	sync()

func _art(texture: Texture2D, position_value: Vector2, size_value: Vector2, parent: Control) -> void:
	var image := TextureRect.new()
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.texture = texture; image.position = position_value; image.size = size_value
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(image)

func _progress(position_value: Vector2, size_value: Vector2, parent: Control) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.position = position_value; bar.size = size_value; bar.show_percentage = false
	bar.add_theme_stylebox_override("background", game._button_style(Color("031422"), Color("8c7046")))
	var fill := StyleBoxFlat.new(); fill.bg_color = Color("70dfcf")
	bar.add_theme_stylebox_override("fill", fill)
	parent.add_child(bar)
	return bar

func _districts() -> void:
	close_all()
	game._toggle_district_panel()

func _note(y: float, text: String) -> void:
	var label: Label = game._label(Vector2(8, y), Vector2(392, 150), 14, Color("b1c9c9"), content)
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _card(key: String, y: float, title: String, detail: String, action: Callable, role: int = -1) -> void:
	var panel: Panel = game.FRAMED_PANEL.instantiate()
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.position = Vector2(2, (152 if sheet_tab == 2 else 158) + cards.size() * 292)
	panel.size = Vector2(400, 280)
	content.add_child(panel)
	var left := 72 if role >= 0 else 12
	if role >= 0:
		var portrait := TextureRect.new()
		var atlas := AtlasTexture.new()
		atlas.atlas = game.STAFF_PORTRAITS
		atlas.region = game.STAFF_PORTRAIT_REGIONS[role]
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.texture = atlas
		portrait.position = Vector2(8, 16)
		portrait.size = Vector2(54, 66)
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(portrait)
	var heading: Label = game._label(Vector2(left, 8), Vector2(388 - left, 28), 18, Color("ffcf71"), panel)
	heading.text = title
	var body: Label = game._label(Vector2(left, 42), Vector2(388 - left, 46), 14, Color("d7e4dd"), panel)
	body.text = detail
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var buy: Button = game._button(Vector2(12, 96), Vector2(376, 48), action, panel)
	buy.add_theme_font_size_override("font_size", game._text_size(15))
	game._primary_button(buy)
	var forecast: Label = game._label(Vector2(12, 154), Vector2(376, 28), 16, Color("70dfcf"), panel)
	var payback: Label = game._label(Vector2(12, 188), Vector2(376, 26), 14, Color("fff0d1"), panel)
	var timing: Label = game._label(Vector2(12, 220), Vector2(376, 52), 14, Color("b1c9c9"), panel)
	timing.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cards[key] = {"panel": panel, "title": heading, "body": body, "buy": buy, "forecast": forecast, "payback": payback, "timing": timing}

func sync() -> void:
	if game.simulation_economy_version < 6: return
	emblem.texture = LOGOS[game.company_logo]
	for i in fleet_counts.size():
		fleet_counts[i].text = game.Numbers.compact(game.staff_counts[i])
		fleet_counts[i].modulate.a = 1.0 if game.staff_counts[i] > 0 else 0.45
	company_progress.text = "Hizmet %d • Prim %d" % [game.service_level, game.bonus_level]
	create_button.disabled = name_field.text.strip_edges().length() < 2
	var snapshot: Dictionary = game._production_snapshot()
	income.text = "~%s ₺ / sn" % game.Numbers.compact(float(snapshot["income"]) / 60.0, 1)
	var target: String = "İtibar: %s / %s ₺" % [game.Numbers.compact(game.run_earned), game.Numbers.compact(game.run_prestige_target)]
	if game.unlocked_district_index < 6:
		target = "%s: %s / %s ₺" % [game.DISTRICTS[game.unlocked_district_index + 1], game.Numbers.compact(game.run_earned), game.Numbers.compact(game.DISTRICT_THRESHOLDS[game.unlocked_district_index + 1])]
	activity.text = "%s • Filo %d\nİtibar %d • %s" % [target, game.workers, game.rebirth_count, snapshot["bottleneck"]]
	reward_badge.text = str(game.Achievements.available(game))
	reward_badge.visible = game.Achievements.available(game) > 0
	if is_instance_valid(flow_note):
		flow_note.visible = sheet_tab != 1
		flow_note.text = "Sipariş %s/dk • Ekip ~%s/dk\nBekleyen %d/30 • Bu tur alınamayan: %s" % [_precise(snapshot["demand"]), _precise(snapshot["capacity"]), game.dispatch.pending.size(), game.Numbers.compact(game.dispatch.missed)]
	if sheet_tab == 1 and is_instance_valid(motivation_body):
		var cost: int = game._motivation_cost()
		motivation_hint.text = "100 teslimat = 1 yıldız • İtibar = 10 yıldız\nBaşarımlardan da kazan › (%d hazır)" % game.Achievements.available(game)
		motivation_balance.text = game.Numbers.compact(game.motivation_stars)
		motivation_bar.value = game.star_progress
		motivation_bar.tooltip_text = "%d / 100 teslimat" % game.star_progress
		var current: float = game._motivation_multiplier()
		var next: float = 1.0 + mini(20, game.motivation_level + 1) * 0.20
		var relative: float = (next / current - 1.0) * 100.0
		motivation_body.text = "SEVİYE %d / 20 • Yeni turda korunur\nToplam ek kazanç: +%d%% → +%d%%\nBu geliştirmeyle ~%%%s daha çok kazan\nSonraki yıldız: %d / 100 teslimat" % [game.motivation_level, game.motivation_level * 20, mini(20, game.motivation_level + 1) * 20, _precise(relative), game.star_progress]
		motivation_buy.text = "TAMAMLANDI" if game.motivation_level >= 20 else ("GELİŞTİR • %d YILDIZ" % cost if game.motivation_stars >= cost else "%d YILDIZ GEREKLİ • %d EKSİK" % [cost, cost - game.motivation_stars])
		motivation_buy.add_theme_color_override("font_disabled_color", Color("e0d6bd"))
		motivation_buy.disabled = game.motivation_level >= 20 or game.motivation_stars < cost
	if sheet_tab == 5:
		flow_note.text = "Hedefleri tamamla, yıldız kazan\nHazır ödül: %d • Ödülü alınan: %d / %d\nYıldızın: %s" % [game.Achievements.available(game), game.achievement_claimed.size(), game.Achievements.ITEMS.size(), game.Numbers.compact(game.motivation_stars)]
		for item in game.Achievements.ITEMS:
			var row: Dictionary = achievement_rows[str(item[0])]
			var value: int = mini(game.Achievements.progress(game, item), int(item[3]))
			var claimed: bool = game.achievement_claimed.has(item[0])
			row["detail"].text = "%s / %s %s" % [game.Numbers.compact(value), game.Numbers.compact(item[3]), {"delivery":"teslimat", "revenue":"₺ toplam ciro", "album":"ilçe", "prestige":"itibar", "motivation":"motivasyon seviyesi"}[item[2]]]
			row["bar"].value = 100.0 * value / float(item[3])
			row["button"].text = "ALINDI" if claimed else ("AL • %d YILDIZ" % item[4] if value >= int(item[3]) else "%d YILDIZ" % item[4])
			row["button"].disabled = claimed or value < int(item[3]) or not game.save_store.writable or game.claim_in_progress
	for key in cards:
		var c: Dictionary = cards[key]
		var role := int(str(key).trim_prefix("fleet")) if str(key).begins_with("fleet") else -1
		var kind: String = "worker" if role >= 0 else str(key)
		var level: int = game.staff_counts[role] if role >= 0 else (game.service_level if kind == "service" else game.get(kind + "_level"))
		var cap: int = 2147483647 if role >= 0 else (game.Economy.MAX_SERVICE_LEVEL if kind == "service" else 20)
		var offer: Dictionary = game._investment(kind, role)
		var complete: bool = level >= cap
		if comparison_buttons.has(key):
			comparison_buttons[key].text = "%s\n%s ₺\n+%s/sn" % [game.STAFF_NAMES[role] if role >= 0 else {"service":"Hizmet", "bonus":"Prim", "comfort":"Konfor"}.get(kind, kind), game.Numbers.compact(offer["cost"]), _precise(float(offer["gain"]) / 60.0)]
			comparison_buttons[key].modulate.a = 0.55 if complete or not str(offer.get("requirement", "")).is_empty() else 1.0
		var requirement: String = offer.get("requirement", "")
		c["body"].text = _effect(kind, role, level, complete)
		c["buy"].text = ("3 ÇALIŞAN" if kind == "bonus" else "MOTOR/ARABA") if not requirement.is_empty() else ("TAMAMLANDI" if complete else "%s ₺" % game.Numbers.compact(offer["cost"]))
		if requirement.is_empty() and not complete and game.money < int(offer["cost"]):
			c["buy"].text += " • %s ₺ eksik" % game.Numbers.compact(int(offer["cost"]) - game.money)
		c["buy"].add_theme_color_override("font_disabled_color", Color("e0d6bd"))
		c["buy"].disabled = complete or not requirement.is_empty() or game.money < int(offer["cost"])
		c["buy"].tooltip_text = "Bu yatırım tamamlandı." if complete else requirement + "\n" + game._investment_tooltip(offer)
		var before_rate: float = float(offer["before"]["income"]) / 60.0
		var after_rate: float = float(offer["after"]["income"]) / 60.0
		c["forecast"].text = "Mevcut ~%s ₺/sn" % _precise(before_rate) if complete else "~%s → %s ₺/sn  (+%s)" % [_precise(before_rate), _precise(after_rate), _precise(float(offer["gain"]) / 60.0)]
		if not requirement.is_empty():
			c["forecast"].text = "Açılınca " + c["forecast"].text
			c["payback"].text = requirement
		elif complete:
			c["payback"].text = "Tüm seviyeler tamamlandı."
		elif float(offer["gain"]) <= 0.001:
			c["payback"].text = "Talep karşılanıyor • Şu an ek gelir sağlamaz."
		else:
			c["payback"].text = "Masrafı çıkarma ~%s • Aynı koşullarda" % _duration(float(offer["payback"]))
		c["timing"].text = "" if complete else _timing(kind)
		c["forecast"].tooltip_text = game._investment_tooltip(offer) if not complete else ""
	_refresh_nav()

func _precise(value: float) -> String:
	if value >= 1000: return game.Numbers.compact(value)
	if value > 0 and value < 0.01: return "<0,01"
	return ("%.2f" % value).trim_suffix("0").trim_suffix("0").trim_suffix(".").replace(".", ",")

func _duration(minutes: float) -> String:
	var seconds := maxi(1, int(round(minutes * 60.0)))
	if seconds < 60: return "%d sn" % seconds
	if seconds < 3600: return "%d dk %d sn" % [seconds / 60, seconds % 60]
	if seconds < 86400: return "%d sa %d dk" % [seconds / 3600, (seconds % 3600) / 60]
	return "%d gün %d sa" % [seconds / 86400, (seconds % 86400) / 3600]

func _effect(kind: String, role: int, level: int, complete: bool) -> String:
	if complete: return "Seviye %d • Son seviye" % level
	if kind == "worker":
		var seconds: float = game._role_seconds(role)
		return "%d → %d kurye\n%s ~%s sn/iş" % [level, level + 1, "Arabayla" if role == 3 else "Ortalama", str(int(round(seconds)))]
	if game.simulation_economy_version >= 7 and kind in ["comfort", "operations"]:
		var offer: Dictionary = game._investment(kind)
		return "Sv.%d → %d • %s öncelikli\nEkip ~%s → %s teslimat/dk" % [level, level+1, "Yaya/bisiklet" if kind == "comfort" else "Motor/araba", _precise(offer["before"]["capacity"]), _precise(offer["after"]["capacity"])]
	var step := 0.25 if kind == "service" else (0.05 if kind in ["bonus", "operations"] else 0.03)
	var current: float = 1.0 + step * level
	var following: float = current + step
	var label := "Ücret" if kind in ["service", "bonus"] else "Hız"
	return "Sv.%d → %d • %s ×%s → ×%s\nBu seviyede %s ~%%%s artar" % [level, level + 1, label, _precise(current), _precise(following), "ücret" if label == "Ücret" else "hız", _precise(step / current * 100)]

func _timing(kind: String) -> String:
	if kind == "worker":
		return "Yeni kurye bekleyen siparişleri de taşır." if not game.dispatch.pending.is_empty() else "Daha çok kazanmak için yeterli sipariş gerekir."
	if not game.dispatch.pending.is_empty():
		return "%d eski iş bekliyor; eski ücretle biter. Geliştirme yeni siparişlerde başlar." % game.dispatch.pending.size()
	return "Yeni siparişlerde geçerli. Yoldaki işler değişmez."

func _build_creation() -> void:
	creation = ColorRect.new()
	creation.color = Color("061721ed")
	creation.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(creation)
	creation_card = game.FRAMED_PANEL.instantiate()
	creation_card.size = Vector2(448, 610)
	creation.add_child(creation_card)
	game._label(Vector2(18, 16), Vector2(350, 30), 23, Color("ffcf71"), creation_card).text = "ŞİRKETİNİ KUR"
	game._button(Vector2(388, 10), Vector2(44, 44), close_all, creation_card).text = "×"
	game._label(Vector2(18, 53), Vector2(410, 40), 13, Color("d7e4dd"), creation_card).text = "Bir isim ve logo seç. İlk yaya kuryen hazır;\nteslimatlar senin şirketin için otomatik başlasın."
	name_field = LineEdit.new()
	name_field.position = Vector2(18, 103)
	name_field.size = Vector2(412, 44)
	name_field.max_length = 24
	name_field.placeholder_text = "Şirket adı (2–24 karakter)"
	name_field.add_theme_stylebox_override("normal", game._button_style(Color("0b2638"), Color("477181")))
	name_field.add_theme_stylebox_override("focus", game._button_style(Color("0b2638"), Color("ffcf71")))
	name_field.text_submitted.connect(func(_text: String) -> void: name_field.release_focus(); DisplayServer.virtual_keyboard_hide())
	creation_card.add_child(name_field)
	game._label(Vector2(18, 159), Vector2(410, 22), 14, Color("70dfcf"), creation_card).text = "ŞİRKET LOGOSU"
	for i in 9:
		var b: Button = game._button(Vector2(26 + (i % 3) * 140, 188 + (i / 3) * 96), Vector2(116, 68), _choose_logo.bind(i), creation_card)
		b.icon = LOGOS[i]
		b.expand_icon = true
		b.add_theme_constant_override("icon_max_width", 44)
		b.tooltip_text = LOGO_NAMES[i]
		logo_buttons.append(b)
		var label: Label = game._label(b.position + Vector2(0, 70), Vector2(116, 20), 12, Color("d7e4dd"), creation_card)
		label.text = LOGO_NAMES[i]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	create_button = game._button(Vector2(18, 537), Vector2(412, 48), _confirm_brand, creation_card)
	game._primary_button(create_button)
	create_button.text = "ŞİRKETİ KUR • 1 YAYA HAZIR"
	name_field.text_changed.connect(func(_text: String) -> void: create_button.disabled = name_field.text.strip_edges().length() < 2)
	creation.hide()

func open_creation() -> void:
	sheet.hide()
	creation.show()
	visible = true
	name_field.text = game.company_name
	logo_choice = game.company_logo
	_choose_logo(logo_choice)
	create_button.text = "KAYDET VE DEVAM ET" if game.brand_ready else "ŞİRKETİ KUR • 1 YAYA HAZIR"
	create_button.disabled = name_field.text.strip_edges().length() < 2

func _choose_logo(index: int) -> void:
	logo_choice = index
	for i in logo_buttons.size(): logo_buttons[i].modulate = Color("ffd184") if i == index else Color.WHITE

func _confirm_brand() -> void:
	game._create_company(name_field.text, logo_choice)
