extends Control
const LOGOS = [preload("res://assets/ui/company/logo_0.svg"), preload("res://assets/ui/company/logo_1.svg"), preload("res://assets/ui/company/logo_2.svg"), preload("res://assets/ui/company/logo_3.svg"), preload("res://assets/ui/company/logo_4.svg"), preload("res://assets/ui/company/logo_5.svg"), preload("res://assets/ui/company/logo_6.svg"), preload("res://assets/ui/company/logo_7.svg"), preload("res://assets/ui/company/logo_8.svg")]
const LOGO_NAMES := ["Kanat", "Pusula", "Şimşek", "Rota", "Kupa", "Taç", "Paket", "Yıldız", "Filo"]
const NAV_ART = preload("res://assets/ui/navigation/nav-icons-v1.png")
const NAV_NAMES := ["Geliştir", "Motivasyon", "Şirket", "Ayarlar"]
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
	activity = game._label(Vector2.ZERO, Vector2(390, 34), 12, Color("d8e4dd"), self)
	emblem = TextureRect.new()
	emblem.position = Vector2(8, 4)
	emblem.size = Vector2(32, 32)
	emblem.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	emblem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(emblem)
	for i in 4:
		var b: Button = game._button(Vector2.ZERO, Vector2(120, 56), open_tab.bind(i), self)
		for row in 2:
			var tile := AtlasTexture.new()
			tile.atlas = NAV_ART
			tile.region = Rect2([68, 494, 918, 1342][i], 56 if row == 0 else 464, 368, 368)
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
	sheet = game.FRAMED_PANEL.instantiate()
	sheet.size = Vector2(456, 428)
	add_child(sheet)
	sheet_title = game._label(Vector2(16, 10), Vector2(365, 30), 21, Color("ffcf71"), sheet)
	game._button(Vector2(398, 8), Vector2(42, 38), close_all, sheet).text = "×"
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
	_build_creation()
	game.resized.connect(layout)
	layout()
	sync()

func _process(_delta: float) -> void:
	visible = creation.visible or (not game.menu_overlay.visible and not game.settings_overlay.visible and not game.return_overlay.visible)
	for node in nav + [income, activity, emblem]: node.visible = not creation.visible

func layout() -> void:
	if nav.is_empty(): return
	var bottom: float = game._bottom_top()
	income.position = Vector2(62, bottom + 10)
	activity.position = Vector2(62, bottom + 43)
	var cell_width: float = game.size.x / 4.0
	for i in 4:
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

func _nav_style(index: int, active: bool, hover: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("103544") if active else (Color("102c3d") if hover else Color("071d2c"))
	style.border_color = Color("8c7046")
	style.border_width_top = 2
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
		var active := i == sheet_tab
		nav[i].icon = nav_pressed[i] if active else nav_normal[i]
		nav[i].add_theme_stylebox_override("normal", _nav_style(i, active))
		nav_markers[i].visible = active

func blocks_map() -> bool:
	return sheet.visible or creation.visible

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
	sheet_title.text = ["GELİŞTİR", "EKİP MOTİVASYONU", "ŞİRKET VE FİLO"][index]
	flow_note = game._label(Vector2(8, 0), Vector2(392, 58), 12, Color("b1c9c9"), content)
	flow_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if index == 0:
		_card("service", 66, "Hizmet Kalitesi", "", game._buy_service)
		_card("bonus", 254, "Teslimat Primi", "", game._buy_company_upgrade.bind("bonus"))
		_note(444, "Katkı ve geri ödeme aynı ilçe/talep için yaklaşık değerlerdir. Kuyruktaki eski işler nedeniyle başlangıçta bu katkıya ulaşılmayabilir; geri ödeme süresi bu beklemeyi içermez.")
		content.custom_minimum_size.y = 550
	elif index == 1:
		_card("comfort", 66, "Çalışma Konforu", "", game._buy_company_upgrade.bind("comfort"))
		_note(256, "Konfor yaya/bisikleti, operasyon motor/araba ekibini daha fazla destekler. Yeni kabul edilen işler hızlanır. Talep zaten karşılanıyorsa hız artışı sürekli geliri artırmayabilir. Etki oyun kapalıyken de sürer.")
		content.custom_minimum_size.y = 374
	else:
		var brand: Label = game._label(Vector2(6, 64), Vector2(390, 26), 18, Color("ffcf71"), content)
		brand.text = game.company_name
		brand.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		game._button(Vector2(6, 96), Vector2(390, 44), open_creation, content).text = "ŞİRKET ADI VE LOGOSU"
		for i in 4: _card("fleet" + str(i), 152 + i * 188, game.STAFF_NAMES[i], "", game._hire_worker.bind(i), i)
		_card("operations", 904, "Operasyon Merkezi", "", game._buy_company_upgrade.bind("operations"))
		game._button(Vector2(6, 1092), Vector2(390, 44), _districts, content).text = "İLÇELER VE İSTANBUL ALBÜMÜ ›"
		_note(1148, ("Uzmanlık: " + game.Specialization.TITLES[game.Specialization.IDS.find(game.specialization_id)] + ". Sonraki itibarda ücretsiz seçim. " if game.rebirth_count > 0 else "Uzmanlık ilk İstanbul İtibarı ile açılır. ") + "Tahminler yeni işler/kuyruk oturduğunda geçerlidir. Geri ödeme, eski işlerin oluşturduğu başlangıç gecikmesini içermez. Karşılanamayan talep kasadan kesilen para değildir.")
		content.custom_minimum_size.y = 1320
	sync()

func _districts() -> void:
	close_all()
	game._toggle_district_panel()

func _note(y: float, text: String) -> void:
	var label: Label = game._label(Vector2(8, y), Vector2(392, 150), 14, Color("b1c9c9"), content)
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _card(key: String, y: float, title: String, detail: String, action: Callable, role: int = -1) -> void:
	var panel: Panel = game.FRAMED_PANEL.instantiate()
	panel.position = Vector2(2, y)
	panel.size = Vector2(400, 176)
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
	var heading: Label = game._label(Vector2(left, 8), Vector2(245 - left, 26), 16, Color("ffcf71"), panel)
	heading.text = title
	var body: Label = game._label(Vector2(left, 40), Vector2(250 - left, 38), 13, Color("d7e4dd"), panel)
	body.text = detail
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var buy: Button = game._button(Vector2(264, 12), Vector2(124, 44), action, panel)
	buy.add_theme_font_size_override("font_size", 12)
	game._primary_button(buy)
	var forecast: Label = game._label(Vector2(12, 82), Vector2(376, 24), 16, Color("70dfcf"), panel)
	var payback: Label = game._label(Vector2(12, 108), Vector2(376, 21), 13, Color("fff0d1"), panel)
	var timing: Label = game._label(Vector2(12, 134), Vector2(376, 34), 12, Color("b1c9c9"), panel)
	timing.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cards[key] = {"title": heading, "body": body, "buy": buy, "forecast": forecast, "payback": payback, "timing": timing}

func sync() -> void:
	if game.simulation_economy_version < 6: return
	emblem.texture = LOGOS[game.company_logo]
	create_button.disabled = name_field.text.strip_edges().length() < 2
	var snapshot: Dictionary = game._production_snapshot()
	income.text = "~%s ₺ / sn" % game.Numbers.compact(float(snapshot["income"]) / 60.0, 1)
	activity.text = "Filo %d • Yolda %d • Teslimat ~%s/dk\n%s • Kuyruk %d/30" % [game.workers, game.dispatch.team_active_count(), game._rate(minf(snapshot["capacity"], snapshot["demand"])), snapshot["bottleneck"], game.dispatch.pending.size()]
	if is_instance_valid(flow_note):
		flow_note.text = "Talep %s/dk • Kapasite ~%s/dk\nKuyruk %d/30 • Bu tur karşılanamayan talep: %s\nTahmini gelir; kasa teslimat tamamlanınca artar." % [_precise(snapshot["demand"]), _precise(snapshot["capacity"]), game.dispatch.pending.size(), game.Numbers.compact(game.dispatch.missed)]
	for key in cards:
		var c: Dictionary = cards[key]
		var role := int(str(key).trim_prefix("fleet")) if str(key).begins_with("fleet") else -1
		var kind: String = "worker" if role >= 0 else str(key)
		var level: int = game.staff_counts[role] if role >= 0 else (game.service_level if kind == "service" else game.get(kind + "_level"))
		var cap: int = 2147483647 if role >= 0 else (game.Economy.MAX_SERVICE_LEVEL if kind == "service" else 20)
		var offer: Dictionary = game._investment(kind, role)
		var complete: bool = level >= cap
		var requirement: String = offer.get("requirement", "")
		c["body"].text = _effect(kind, role, level, complete)
		c["buy"].text = ("3 ÇALIŞAN" if kind == "bonus" else "MOTOR/ARABA") if not requirement.is_empty() else ("TAMAMLANDI" if complete else "%s ₺" % game.Numbers.compact(offer["cost"]))
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
			c["payback"].text = "Talep karşılanıyor • Sürekli gelir katkısı yok."
		else:
			c["payback"].text = "Geri ödeme ~%s • Aynı ilçe ve koşullarda" % _duration(float(offer["payback"]))
		c["timing"].text = "" if complete else _timing(kind)
		c["forecast"].tooltip_text = game._investment_tooltip(offer) if not complete else ""
	_refresh_nav()

func _precise(value: float) -> String:
	if value >= 1000: return game.Numbers.compact(value)
	if value > 0 and value < 0.01: return "<0,01"
	return ("%.2f" % value).trim_suffix("0").trim_suffix("0").trim_suffix(".").replace(".", ",")

func _duration(minutes: float) -> String:
	if minutes < 60: return "%s dk" % _precise(minutes)
	if minutes < 1440: return "%s sa" % _precise(minutes / 60.0)
	return "%s gün" % _precise(minutes / 1440.0)

func _effect(kind: String, role: int, level: int, complete: bool) -> String:
	if complete: return "Seviye %d • Son seviye" % level
	if kind == "worker":
		var seconds: float = game._role_seconds(role)
		return "%d → %d kurye\n%s ~%s sn/iş" % [level, level + 1, "Toplu dağıtım" if role == 3 else "Ortalama", _precise(seconds)]
	if game.simulation_economy_version >= 7 and kind in ["comfort", "operations"]:
		var offer: Dictionary = game._investment(kind)
		return "Sv.%d → %d • %s öncelikli\nKapasite ~%s → %s iş/dk" % [level, level+1, "Yaya/bisiklet" if kind == "comfort" else "Motor/araba", _precise(offer["before"]["capacity"]), _precise(offer["after"]["capacity"])]
	var step := 0.25 if kind == "service" else (0.05 if kind in ["bonus", "operations"] else 0.03)
	var current: float = 1.0 + step * level
	var following: float = current + step
	var label := "Ücret" if kind in ["service", "bonus"] else "Hız"
	return "Sv.%d → %d • %s ×%s → ×%s\nMevcut %s artışı ~%%%s" % [level, level + 1, label, _precise(current), _precise(following), "ücret" if label == "Ücret" else "hız", _precise(step / current * 100)]

func _timing(kind: String) -> String:
	if kind == "worker":
		return "Yeni kurye bekleyen işleri de alabilir." if not game.dispatch.pending.is_empty() else "Katkı, yeterli sipariş geldiğinde oluşur."
	if not game.dispatch.pending.is_empty():
		return "Kuyrukta %d eski iş: etki gecikebilir. Kabul edilmiş işler değişmez." % game.dispatch.pending.size()
	return "Yeni kabul edilen işlerde geçerli. Aktif işlerin koşulları değişmez."

func _build_creation() -> void:
	creation = ColorRect.new()
	creation.color = Color("061721ed")
	creation.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(creation)
	creation_card = game.FRAMED_PANEL.instantiate()
	creation_card.size = Vector2(448, 610)
	creation.add_child(creation_card)
	game._label(Vector2(18, 16), Vector2(350, 30), 23, Color("ffcf71"), creation_card).text = "ŞİRKETİNİ KUR"
	game._button(Vector2(390, 12), Vector2(40, 38), close_all, creation_card).text = "×"
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
