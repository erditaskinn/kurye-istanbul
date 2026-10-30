extends Control
const Specialization = preload("res://scripts/specialization.gd")
const Achievements = preload("res://scripts/achievements.gd")
var lifetime_deliveries := 0
var achievement_claimed: Array[String] = []
var motivation_stars := 0
var motivation_level := 0
var star_progress := 0
var specialization_id := "standard"
var model_menu: AcceptDialog
var specialization_choice: OptionButton
var deliveries_label: Label
var revenue_label: Label
var money_label: Label
var district_button: Button
var title_label: Label
var header_font: Font
const HEADER_FONT = preload("res://assets/fonts/Tiny5.ttf")
const HEADER_PANELS = [preload("res://assets/ui/header/v2/cash.png"), preload("res://assets/ui/header/v2/revenue.png"), preload("res://assets/ui/header/v2/deliveries.png"), preload("res://assets/ui/header/v2/district.png")]
var header_panels: Array[AtlasTexture] = []

const StaticMapView = preload("res://scripts/static_map_view.gd")
var map_view: RefCounted

const HudPresenter = preload("res://scripts/hud_presenter.gd")
var hud: RefCounted

const GameFeedback = preload("res://scripts/game_feedback.gd")
var feedback: Control
var sound_enabled := false
var haptics_enabled := false
var sound_button: Button
var haptics_button: Button

const CompanyUI = preload("res://scripts/company_ui.gd")
var company_ui: Control
var company_name := ""
var company_logo := 0
var brand_ready := false
var bonus_level := 0
var operations_level := 0
var comfort_level := 0
var run_prestige_target := Economy.REBIRTH_THRESHOLD
var legacy_speed_floor: Array = []
var starter_role := 0
const Numbers = preload("res://scripts/number_format.gd")
const PixelStyle = preload("res://scripts/pixel_style.gd")
const SHOP_PIXELS = [preload("res://assets/ui/pixel/shop_0.svg"), preload("res://assets/ui/pixel/shop_1.svg"), preload("res://assets/ui/pixel/shop_2.svg"), preload("res://assets/ui/pixel/shop_3.svg"), preload("res://assets/ui/pixel/shop_4.svg"), preload("res://assets/ui/pixel/shop_5.svg"), preload("res://assets/ui/pixel/shop_6.svg"), preload("res://assets/ui/pixel/shop_7.svg")]
const HOME_PIXELS = [preload("res://assets/ui/pixel/home_0.svg"), preload("res://assets/ui/pixel/home_1.svg"), preload("res://assets/ui/pixel/home_2.svg"), preload("res://assets/ui/pixel/home_3.svg"), preload("res://assets/ui/pixel/home_4.svg"), preload("res://assets/ui/pixel/home_5.svg"), preload("res://assets/ui/pixel/home_6.svg"), preload("res://assets/ui/pixel/home_7.svg")]
const Economy = preload("res://scripts/economy.gd")
const LocalMetrics = preload("res://scripts/local_metrics.gd")
var local_metrics := LocalMetrics.new()
const SaveStore = preload("res://scripts/save_store.gd")
var save_store := SaveStore.new()
var application_suspended := false

const RoadNetwork = preload("res://scripts/road_network.gd")
const Dispatch = preload("res://scripts/dispatch.gd")
const Iso = preload("res://scripts/isometric_projection.gd")
const STATIC_MAP_SILE = preload("res://assets/maps/sile_sabit.png")
const STATIC_MAP_BEYKOZ = preload("res://assets/maps/beykoz_sabit.png")
const STATIC_MAP_USKUDAR = preload("res://assets/maps/uskudar_sabit.png")
const STATIC_MAP_KADIKOY = preload("res://assets/maps/kadikoy_sabit.png")
const STATIC_MAP_BESIKTAS = preload("res://assets/maps/besiktas_sabit.png")
const STATIC_MAP_SISLI = preload("res://assets/maps/sisli_sabit.png")
const STATIC_MAP_BEYOGLU = preload("res://assets/maps/beyoglu_sabit.png")
const STATIC_MAP_CITY = preload("res://assets/maps/istanbul_sabit.png")
const UI_THEME = preload("res://assets/ui/istanbul_theme.tres")
const FRAMED_PANEL = preload("res://scenes/ui/FramedPanel.tscn")
const MENU_ART = preload("res://assets/ui/menu_sahil.png")
const STAFF_PORTRAITS = preload("res://assets/ui/ekip_portreleri.png")
const STAFF_PORTRAIT_REGIONS := [Rect2(20, 100, 425, 560), Rect2(475, 100, 495, 560), Rect2(975, 100, 550, 560), Rect2(1540, 100, 620, 560)]
const UI_ICONS = {
	"money": preload("res://assets/ui/pixel/money.svg"),
	"package": preload("res://assets/ui/pixel/package.svg"),
	"route": preload("res://assets/ui/pixel/route.svg"),
	"team": preload("res://assets/ui/ekip.svg"),
	"settings": preload("res://assets/ui/pixel/settings.svg"),
	"plus": preload("res://assets/ui/arti.svg"),
	"minus": preload("res://assets/ui/eksi.svg"),
	"center": preload("res://assets/ui/odak.svg"),
	"shop": preload("res://assets/ui/pixel/shop.svg"),
	"home": preload("res://assets/ui/pixel/home.svg"),
}
const LOCATION_POSITIONS := [
	Vector2(0.62, 0.475), Vector2(0.80, 0.31), Vector2(0.43, 0.52), Vector2(0.91, 0.64),
	Vector2(0.18, 0.63), Vector2(0.68, 0.67), Vector2(0.52, 0.72), Vector2(0.82, 0.48),
	Vector2(0.92, 0.30), Vector2(0.69, 0.36), Vector2(0.94, 0.42), Vector2(0.94, 0.54),
	Vector2(0.79, 0.58), Vector2(0.36, 0.63), Vector2(0.72, 0.75), Vector2(0.94, 0.74),
]
const CITY_LOCATION_POSITIONS := [
	Vector2(0.29, 0.29), Vector2(0.65, 0.40), Vector2(0.92, 0.47), Vector2(0.57, 0.55),
	Vector2(0.20, 0.46), Vector2(0.37, 0.64), Vector2(0.70, 0.68), Vector2(0.90, 0.74),
	Vector2(0.47, 0.29), Vector2(0.73, 0.30), Vector2(0.90, 0.34), Vector2(0.93, 0.60),
	Vector2(0.40, 0.50), Vector2(0.53, 0.70), Vector2(0.31, 0.75), Vector2(0.80, 0.55),
]
const BEYKOZ_LOCATION_POSITIONS := [
 Vector2(0.70, 0.20), Vector2(0.82, 0.20), Vector2(0.94, 0.20), Vector2(0.80, 0.30),
 Vector2(0.94, 0.30), Vector2(0.80, 0.40), Vector2(0.94, 0.40), Vector2(0.80, 0.50),
 Vector2(0.94, 0.50), Vector2(0.80, 0.58), Vector2(0.94, 0.58), Vector2(0.80, 0.70),
 Vector2(0.94, 0.70), Vector2(0.12, 0.30), Vector2(0.26, 0.34), Vector2(0.42, 0.37),
]
const USKUDAR_LOCATION_POSITIONS := [
 Vector2(0.42, 0.16), Vector2(0.55, 0.16), Vector2(0.68, 0.16), Vector2(0.81, 0.16),
 Vector2(0.94, 0.16), Vector2(0.94, 0.27), Vector2(0.94, 0.37), Vector2(0.94, 0.47),
 Vector2(0.94, 0.57), Vector2(0.94, 0.67), Vector2(0.08, 0.72), Vector2(0.22, 0.72),
 Vector2(0.36, 0.72), Vector2(0.50, 0.72), Vector2(0.64, 0.72), Vector2(0.79, 0.72),
]
const BESIKTAS_LOCATION_POSITIONS := [
 Vector2(0.06, 0.21), Vector2(0.20, 0.21), Vector2(0.34, 0.21), Vector2(0.48, 0.21),
 Vector2(0.62, 0.21), Vector2(0.06, 0.32), Vector2(0.06, 0.42), Vector2(0.06, 0.52),
 Vector2(0.06, 0.62), Vector2(0.06, 0.72), Vector2(0.20, 0.70), Vector2(0.34, 0.70),
 Vector2(0.48, 0.70), Vector2(0.20, 0.55), Vector2(0.34, 0.55), Vector2(0.50, 0.58),
]
const KADIKOY_LOCATION_POSITIONS := [
 Vector2(0.80, 0.17), Vector2(0.94, 0.17), Vector2(0.80, 0.25), Vector2(0.94, 0.25),
 Vector2(0.80, 0.33), Vector2(0.94, 0.33), Vector2(0.80, 0.41), Vector2(0.94, 0.41),
 Vector2(0.80, 0.49), Vector2(0.94, 0.49), Vector2(0.80, 0.60), Vector2(0.94, 0.60),
 Vector2(0.64, 0.17), Vector2(0.64, 0.25), Vector2(0.64, 0.34), Vector2(0.64, 0.58),
]
const SISLI_LOCATION_POSITIONS := [
 Vector2(0.06, 0.18), Vector2(0.94, 0.18), Vector2(0.06, 0.28), Vector2(0.94, 0.28),
 Vector2(0.06, 0.38), Vector2(0.94, 0.38), Vector2(0.06, 0.47), Vector2(0.94, 0.47),
 Vector2(0.06, 0.55), Vector2(0.94, 0.55), Vector2(0.06, 0.65), Vector2(0.94, 0.65),
 Vector2(0.25, 0.18), Vector2(0.55, 0.18), Vector2(0.75, 0.18), Vector2(0.23, 0.64),
]
const BEYOGLU_LOCATION_POSITIONS := [
 Vector2(0.06, 0.17), Vector2(0.78, 0.35), Vector2(0.06, 0.27), Vector2(0.94, 0.27),
 Vector2(0.06, 0.37), Vector2(0.94, 0.37), Vector2(0.06, 0.45), Vector2(0.94, 0.45),
 Vector2(0.06, 0.53), Vector2(0.94, 0.53), Vector2(0.06, 0.64), Vector2(0.94, 0.64),
 Vector2(0.48, 0.17), Vector2(0.62, 0.17), Vector2(0.48, 0.53), Vector2(0.45, 0.63),
]
const SAVE_PATH := "user://kurye_save.json"
const SILE_MAP_PATH := "res://assets/maps/sile.json"
const WORLD_BOUNDS := Rect2(0, 0, 480, 800)
const SILE_VIEW_BOUNDS := Rect2(-90, 0, 660, 800)
const MAP_TOP := 114.0
const BOTTOM_HEIGHT := 144.0
const MAX_MAP_ZOOM := 3.2
const ROAD_X := [63.0, 147.0, 333.0, 419.0]
const ROAD_Y := [184.0, 274.0, 363.0, 454.0, 543.0]
const EMPTY_LOTS := [Vector2i(7, 212), Vector2i(89, 303), Vector2i(356, 128), Vector2i(434, 303), Vector2i(7, 483), Vector2i(89, 483), Vector2i(434, 483)]
const DISTRICT_OPEN_LOTS := [
	[Vector2i(7, 212), Vector2i(89, 303), Vector2i(356, 128), Vector2i(434, 303), Vector2i(7, 483), Vector2i(89, 483), Vector2i(434, 483), Vector2i(7, 128), Vector2i(89, 128), Vector2i(356, 483)],
	[Vector2i(7, 212), Vector2i(89, 303), Vector2i(356, 128), Vector2i(434, 303), Vector2i(7, 483), Vector2i(89, 483), Vector2i(434, 483), Vector2i(7, 128), Vector2i(356, 392)],
	EMPTY_LOTS,
	[Vector2i(7, 212), Vector2i(89, 303), Vector2i(356, 128), Vector2i(434, 303), Vector2i(7, 483), Vector2i(89, 483)],
	[Vector2i(7, 212), Vector2i(89, 303), Vector2i(356, 128), Vector2i(434, 303), Vector2i(89, 483)],
	[Vector2i(7, 212), Vector2i(89, 303), Vector2i(356, 128), Vector2i(434, 303)],
	[Vector2i(7, 212), Vector2i(89, 303), Vector2i(356, 128), Vector2i(434, 303)],
]
const PICKUPS := [
	{"name": "İskele Simit", "item": "simit", "position": Vector2(63, 184)},
	{"name": "Kule Kahve", "item": "kahve", "position": Vector2(333, 184)},
	{"name": "Yokuş Fırın", "item": "ekmek", "position": Vector2(147, 454)},
	{"name": "Sahil Börek", "item": "börek", "position": Vector2(419, 543)},
	{"name": "Martı Çorba", "item": "çorba", "position": Vector2(63, 363)},
	{"name": "Meydan Kafe", "item": "paket", "position": Vector2(333, 363)},
	{"name": "Çınar Lokanta", "item": "yemek", "position": Vector2(147, 274)},
	{"name": "Liman Çay", "item": "çay", "position": Vector2(419, 274)},
]
const DROPS := [
	{"name": "Mavi Apartmanı", "position": Vector2(333, 274)},
	{"name": "Çınar Apartmanı", "position": Vector2(147, 274)},
	{"name": "Işık Apartmanı", "position": Vector2(419, 454)},
	{"name": "Deniz Apartmanı", "position": Vector2(63, 543)},
	{"name": "Arda Apartmanı", "position": Vector2(147, 184)},
	{"name": "Pera Apartmanı", "position": Vector2(333, 543)},
	{"name": "Güneş Apartmanı", "position": Vector2(63, 454)},
	{"name": "Ayaz Apartmanı", "position": Vector2(419, 184)},
]
const VEHICLES := ["YAYA", "BİSİKLET", "MOTOR", "HIZLI MOTOR"]
const SPEEDS = Economy.SPEEDS
const COSTS = Economy.COSTS
const COMPANY_COST = Economy.COMPANY_COST
const STAFF_NAMES := ["YAYA", "BİSİKLET", "MOTOR", "ARABA"]
const STAFF_COSTS = Economy.STAFF_COSTS
const OFFLINE_LIMIT_SECONDS = Economy.OFFLINE_LIMIT_SECONDS
const OFFLINE_RATE_PER_MINUTE = Economy.OFFLINE_RATE_PER_MINUTE
# Game demand grows along a plausible route from the quieter outskirts toward
# central commercial areas. This is not a population ranking.
const DISTRICTS := ["Şile", "Beykoz", "Üsküdar", "Kadıköy", "Beşiktaş", "Şişli", "Beyoğlu"]
const DISTRICT_THRESHOLDS = Economy.DISTRICT_THRESHOLDS
const REBIRTH_THRESHOLD = Economy.REBIRTH_THRESHOLD

var roads := RoadNetwork.new()
var sile_map: Dictionary = {}
var road_district_index := -1
var dispatch := Dispatch.new()
var simulation_initialized := false
var advance_report: Dictionary = {"solo": 0, "team": 0, "completed": 0}
var rng := RandomNumberGenerator.new()
var player := Vector2(147, 363)
var facing := 0
var waypoints: Array[Vector2] = []
var money := Economy.STARTING_CASH
var service_level := 0
var simulation_economy_version := Economy.VERSION
var market_cache: Dictionary = {}
var route_distance_cache: Dictionary = {}
var migration_notice := ""
var migration_dialog: AcceptDialog
var total_earned := 0
var run_earned := 0
var district_index := 0
var unlocked_district_index := 0
var album_unlocked: Array[int] = [0]
var district_selection := 0
var district_select_buttons: Array[Button] = []
var district_activate_button: Button
var district_postcard: TextureRect
var district_comparison: Label
var album_button: Button
var album_panel: Control
var album_scroll: ScrollContainer
var album_images: Array[TextureRect] = []
var album_labels: Array[Label] = []
var rebirth_count := 0
var deliveries := 0
var vehicle := 0
var company := false
var workers := 0
var staff_counts: Array[int] = [0, 0, 0, 0]
var carrying := false
var pickup_index := 0
var drop_index := 0
var order_payout := 0
var phase_start_distance := 1.0
var pulse := 0.0
var save_clock := 0.0
var last_saved_at := 0
var message := "Kurye ilk siparişe gidiyor!"
var message_clock := 5.0
var team_notice_clock := 0.0
var last_team_payout := 0
var has_started := false
var camera_center := Vector2(240, 363)
var camera_zoom := 2.1
var camera_follow := true
var touch_points: Dictionary = {}
var touch_starts: Dictionary = {}
var touch_moved: Dictionary = {}
var mouse_down := false
var mouse_start := Vector2.ZERO
var mouse_dragged := false

var guide_seen := false
var guide_panel: Control
var guide_title: Label
var guide_body: Label
var guide_goal: Label
var menu_overlay: ColorRect
var menu_title: Label
var menu_subtitle: Label
var menu_start_button: Button
var menu_settings_button: Button
var settings_overlay: ColorRect
var settings_panel: Panel
var reset_dialog: ConfirmationDialog
var district_panel: Panel
var district_name_label: Label
var district_progress_label: Label
var district_bonus_label: Label
var rebirth_button: Button
var rebirth_dialog: ConfirmationDialog
var prestige_shade: ColorRect
var district_progress_bar: ProgressBar
var hud_card_style: StyleBox
var mission_card_style: StyleBox
var location_style: StyleBox
var active_location_style: StyleBox
var active_location_glow: StyleBox
var pickup_location_style: StyleBox
var drop_location_style: StyleBox
var drop_location_glow: StyleBox
var last_map_animation_frame := -1
var return_summary: Dictionary = {}
var return_overlay: ColorRect
var return_panel: Panel
var return_time_label: Label
var return_total_label: Label
var return_breakdown_label: Label
var return_goal_label: Label
var return_choices: Array[Dictionary] = []
var return_choice_buttons: Array[Button] = []

var selected_location := -1
var location_panel: Panel
var location_type_label: Label
var location_name_label: Label
var location_role_label: Label
var location_icon: TextureRect

func _ready() -> void:
	map_view = StaticMapView.new(self)
	get_tree().quit_on_go_back = false
	if OS.has_feature("mobile"):
		Engine.max_fps = 30
	theme = UI_THEME
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	hud_card_style = _button_style(Color("071d2c"), Color("315367"))
	mission_card_style = _button_style(Color("0b2638"), Color("315367"))
	location_style = _button_style(Color("09283c", 0.92), Color("75b6bb"))
	active_location_style = _button_style(Color("102536"), Color("ffc45f"))
	active_location_glow = _button_style(Color("24495a"), Color("ffe49a"))
	pickup_location_style = _button_style(Color("163244"), Color("ffc45f"))
	drop_location_style = _button_style(Color("123d46"), Color("70dfcf"))
	drop_location_glow = _button_style(Color("1d5960"), Color("b4fff0"))
	rng.randomize()
	sile_map = JSON.parse_string(FileAccess.get_file_as_string(SILE_MAP_PATH))
	_build_roads()
	player = _district_spawn()
	camera_center = player + Vector2(0, 55)
	_load_game()
	if road_district_index != district_index:
		_build_roads()
		player = _district_spawn()
	if order_payout <= 0:
		order_payout = _calculate_payout(pickup_index, drop_index)
	if not simulation_initialized:
		_seed_founder_job()
	_build_ui()
	_build_menus()
	_build_return_summary()
	_build_migration_dialog()
	company_ui = CompanyUI.new()
	company_ui.game = self
	add_child(company_ui)
	feedback = GameFeedback.new()
	feedback.game = self
	add_child(feedback)
	resized.connect(_layout_ui)
	_layout_ui()
	_route_to_mission()
	_refresh_ui()
	_save_game()
	queue_redraw()

func _notification(what: int) -> void:
	if not is_node_ready():
		return
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_handle_android_back()
	elif what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_game()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		application_suspended = true
		if is_instance_valid(feedback): feedback.clear()
		_save_game()
	elif what == NOTIFICATION_APPLICATION_RESUMED:
		application_suspended = false
		if not has_started:
			last_saved_at = int(Time.get_unix_time_from_system())
			_save_game()
			return
		var income := _apply_offline_income()
		if income > 0:
			_announce("Sen yokken +%s ₺ kazanıldı!" % Numbers.compact(income))
		_save_game()
		_refresh_ui()
		_show_return_summary()

func _build_roads() -> void:
	# Distances are geometry-only. Rebuilding the graph invalidates all entries.
	route_distance_cache.clear()
	roads = RoadNetwork.new()
	road_district_index = district_index
	if district_index == 0:
		for point in sile_map["nodes"]:
			roads.add_node(Vector2(float(point[0]), float(point[1])))
		for edge in sile_map["edges"]:
			roads.connect_nodes(int(edge[0]), int(edge[1]))
	else:
		_build_shared_roads()

func _build_shared_roads() -> void:
	for y in ROAD_Y:
		for x in ROAD_X:
			roads.add_node(Vector2(x, y))
	for row in ROAD_Y.size():
		for column in ROAD_X.size():
			var node: int = row * ROAD_X.size() + column
			if row + 1 < ROAD_Y.size():
				roads.connect_nodes(node, node + ROAD_X.size())
			if column == 0 or column == 2 or (row == 2 and column == 1):
				roads.connect_nodes(node, node + 1)

func _district_spawn() -> Vector2:
	return roads.nodes[int(sile_map["spawn_node"])] if district_index == 0 else Vector2(147, 363)

func _pickup_position(index: int) -> Vector2:
	return roads.nodes[int(sile_map["pickup_nodes"][index])] if district_index == 0 else PICKUPS[index]["position"]

func _drop_position(index: int) -> Vector2:
	return roads.nodes[int(sile_map["drop_nodes"][index])] if district_index == 0 else DROPS[index]["position"]

func _build_ui() -> void:
	hud = HudPresenter.new(self)
	hud.build()
	_build_location_panel()
	_build_district_panel()
	_build_guide()

func _build_location_panel() -> void:
	location_panel = FRAMED_PANEL.instantiate()
	location_panel.size = Vector2(448, 136)
	location_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(location_panel)
	location_icon = TextureRect.new()
	location_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	location_icon.position = Vector2(16, 17)
	location_icon.size = Vector2(34, 34)
	location_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	location_panel.add_child(location_icon)
	location_type_label = _label(Vector2(62, 10), Vector2(310, 20), 12, Color("a6b9c5"), location_panel)
	location_name_label = _label(Vector2(62, 31), Vector2(310, 26), 20, Color("fff0d1"), location_panel)
	location_role_label = _label(Vector2(16, 58), Vector2(414, 32), 13, Color("fff0d1"), location_panel)
	location_role_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var close := _button(Vector2(388, 10), Vector2(44, 44), _close_location_card, location_panel)
	close.text = "×"
	var automation_note := _label(Vector2(16, 96), Vector2(416, 26), 12, Color("70dfcf"), location_panel)
	automation_note.text = "Teslimatlar otomatik sürer • Bu kart yalnızca bilgi verir"
	location_panel.visible = false

func _close_location_card() -> void:
	selected_location = -1
	if location_panel != null:
		location_panel.visible = false
	queue_redraw()

func _refresh_location_card() -> void:
	if selected_location < 0 or location_panel == null:
		return
	var is_shop := selected_location < PICKUPS.size()
	var index := selected_location if is_shop else selected_location - PICKUPS.size()
	var accent := Color("ffc45f") if is_shop else Color("70dfcf")
	location_icon.texture = SHOP_PIXELS[selected_location] if is_shop else HOME_PIXELS[selected_location - PICKUPS.size()]
	location_type_label.text = "%s • %s" % ["DÜKKÂN" if is_shop else "EV", DISTRICTS[district_index].to_upper()]
	location_type_label.add_theme_color_override("font_color", accent)
	location_name_label.text = PICKUPS[index]["name"] if is_shop else DROPS[index]["name"]
	location_panel.add_theme_stylebox_override("panel", _button_style(Color("071d2c"), accent))
	var job := _focus_job()
	var active_here := not job.is_empty() and int(job.get("district", district_index)) == district_index
	if active_here and is_shop and index == pickup_index:
		location_role_label.text = "Bu siparişin alım noktası • " + ("Paket alındı" if carrying else "Sıradaki durak")
	elif active_here and not is_shop and index == drop_index:
		location_role_label.text = "Bu siparişin teslimat noktası • " + ("Sıradaki durak" if carrying else "Alımdan sonra")
	else:
		location_role_label.text = "Sipariş noktası • %s" % (str(PICKUPS[index]["item"]).capitalize() if is_shop else "Apartman teslimatı")

func _build_menus() -> void:
	menu_overlay = ColorRect.new()
	menu_overlay.color = Color("102536")
	menu_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(menu_overlay)
	var menu_background := TextureRect.new()
	menu_background.texture = MENU_ART
	menu_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	menu_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	menu_background.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_overlay.add_child(menu_background)
	var menu_tint := ColorRect.new()
	menu_tint.color = Color("061b2c", 0.30)
	menu_tint.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_overlay.add_child(menu_tint)
	menu_title = _label(Vector2.ZERO, Vector2(440, 106), 39, Color("fff0d1"), menu_overlay)
	menu_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_title.add_theme_constant_override("outline_size", 6)
	menu_title.add_theme_color_override("font_outline_color", Color("061b2c"))
	menu_title.text = "İSTANBUL\nKURYE"
	menu_subtitle = _label(Vector2.ZERO, Vector2(420, 60), 16, Color("d9e6dc"), menu_overlay)
	menu_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_subtitle.add_theme_constant_override("outline_size", 4)
	menu_subtitle.add_theme_color_override("font_outline_color", Color("061b2c"))
	menu_subtitle.text = "Şile'den başla, teslimat yap, kurye şirketini büyüt."
	menu_start_button = _button(Vector2.ZERO, Vector2(360, 58), _start_playing, menu_overlay)
	_primary_button(menu_start_button)
	menu_start_button.text = "DEVAM ET" if has_started else "OYUNA BAŞLA"
	menu_settings_button = _button(Vector2.ZERO, Vector2(360, 52), _open_settings, menu_overlay)
	menu_settings_button.text = "AYARLAR"
	settings_overlay = ColorRect.new()
	settings_overlay.color = Color("071721", 0.85)
	settings_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(settings_overlay)
	settings_panel = FRAMED_PANEL.instantiate()
	settings_panel.size = Vector2(420, 408)
	settings_overlay.add_child(settings_panel)
	_label(Vector2(22, 19), Vector2(315, 38), 24, Color("f9b553"), settings_panel).text = "AYARLAR"
	_button(Vector2(356, 16), Vector2(44, 44), _close_settings, settings_panel).text = "X"
	sound_button = _button(Vector2(22, 72), Vector2(376, 44), _toggle_sound, settings_panel)
	haptics_button = _button(Vector2(22, 126), Vector2(376, 44), _toggle_haptics, settings_panel)
	_refresh_feedback_buttons()
	_label(Vector2(22, 182), Vector2(376, 30), 12, Color("b1c9c9"), settings_panel).text = "Kısa, kısık efektler. Titreşim yalnız alım/açılışta."
	_label(Vector2(22, 216), Vector2(376, 20), 11, Color("70dfcf"), settings_panel).text = "K: bin • M: milyon • B: milyar • T: trilyon"
	_label(Vector2(22, 244), Vector2(376, 32), 13, Color("d9e6dc"), settings_panel).text = "Sıfırlama şirket ve ilerlemeyi başa alır.\nSes ve titreşim tercihin korunur."
	var reset_button := _button(Vector2(22, 282), Vector2(376, 44), _request_reset, settings_panel)
	reset_button.text = "OYUNU SIFIRLA"
	reset_button.add_theme_stylebox_override("normal", _button_style(Color("713b3d"), Color("d4816e")))
	_button(Vector2(22, 342), Vector2(182, 46), _close_settings, settings_panel).text = "GERİ DÖN"
	_button(Vector2(216, 342), Vector2(182, 46), _back_to_menu, settings_panel).text = "ANA MENÜ"
	settings_overlay.visible = false
	reset_dialog = ConfirmationDialog.new()
	reset_dialog.title = "Oyunu Sıfırla"
	reset_dialog.dialog_text = "Tüm oyun ilerlemen bu cihazda silinecek.\nBu işlem geri alınamaz."
	reset_dialog.ok_button_text = "Evet, Sıfırla"
	reset_dialog.cancel_button_text = "İptal"
	_style_confirmation(reset_dialog, true)
	reset_dialog.confirmed.connect(_reset_progress)
	add_child(reset_dialog)

func _start_playing() -> void:
	if simulation_economy_version >= 6 and not brand_ready:
		company_ui.open_creation()
		return
	if has_started:
		var income := _apply_offline_income()
		if income > 0:
			_announce("Sen yokken +%s ₺ kazanıldı!" % Numbers.compact(income))
	else:
		last_saved_at = int(Time.get_unix_time_from_system())
		local_metrics.begin_visit()
		local_metrics.record("automation_started", {"reputation": rebirth_count}, true)
	has_started = true
	menu_overlay.visible = false
	menu_start_button.text = "DEVAM ET"
	_save_game()
	_refresh_ui()
	queue_redraw()
	_show_return_summary()
	_show_migration_notice()

func _open_settings() -> void:
	guide_panel.hide()
	if is_instance_valid(feedback): feedback.clear()
	_close_location_card()
	if not menu_overlay.visible:
		_save_game()
	settings_overlay.visible = true

func _settle_settings_time() -> void:
	if settings_overlay != null and settings_overlay.visible and has_started and not menu_overlay.visible and int(Time.get_unix_time_from_system()) > last_saved_at:
		_apply_offline_income()

func _refresh_feedback_buttons() -> void:
	if sound_button != null: sound_button.text = "SES EFEKTLERİ: " + ("AÇIK" if sound_enabled else "KAPALI")
	if haptics_button != null: haptics_button.text = "TİTREŞİM: " + ("AÇIK" if haptics_enabled else "KAPALI")

func _toggle_sound() -> void:
	_settle_settings_time()
	sound_enabled = not sound_enabled
	_refresh_feedback_buttons()
	_save_game()
	if is_instance_valid(feedback):
		if sound_enabled: feedback.play_sound("purchase")
		else: feedback.player.stop()

func _toggle_haptics() -> void:
	_settle_settings_time()
	haptics_enabled = not haptics_enabled
	_refresh_feedback_buttons()
	_save_game()
	if is_instance_valid(feedback) and haptics_enabled: feedback.haptic()

func _close_settings() -> void:
	settings_overlay.visible = false
	if not menu_overlay.visible:
		var income := _apply_offline_income()
		if income > 0:
			_announce("Sen yokken +%s ₺ kazanıldı!" % Numbers.compact(income))
		_save_game()
		_refresh_ui()
		_show_return_summary()

func _back_to_menu() -> void:
	_settle_settings_time()
	if not menu_overlay.visible:
		_save_game()
	_close_location_card()
	settings_overlay.visible = false
	menu_overlay.visible = true
	menu_start_button.text = "DEVAM ET" if has_started else "OYUNA BAŞLA"

func _request_reset() -> void:
	reset_dialog.popup_centered(Vector2i(400, 180))

func _reset_progress() -> void:
	guide_panel.hide()
	if is_instance_valid(feedback): feedback.clear()
	_close_location_card()
	return_summary.clear()
	guide_seen = false
	local_metrics = LocalMetrics.new()
	company_name = ""
	company_logo = 0
	brand_ready = false
	bonus_level = 0
	operations_level = 0
	comfort_level = 0
	run_prestige_target = Economy.REBIRTH_THRESHOLD
	legacy_speed_floor = []
	starter_role = 0
	if company_ui != null: company_ui.close_all()
	album_unlocked.assign([0])
	album_panel.hide()
	migration_notice = ""
	migration_dialog.hide()
	rebirth_dialog.hide()
	return_overlay.visible = false
	money = Economy.STARTING_CASH
	service_level = 0
	total_earned = 0
	run_earned = 0
	district_index = 0
	unlocked_district_index = 0
	district_selection = 0
	_build_roads()
	lifetime_deliveries = 0
	achievement_claimed.clear()
	motivation_stars = 0
	motivation_level = 0
	star_progress = 0
	specialization_id = "standard"
	rebirth_count = 0
	deliveries = 0
	vehicle = 0
	company = false
	workers = 0
	staff_counts = [0, 0, 0, 0]
	dispatch.reset()
	carrying = false
	player = _district_spawn()
	pickup_index = 0
	drop_index = 0
	order_payout = _calculate_payout(pickup_index, drop_index)
	camera_center = _district_spawn() + Vector2(0, 55)
	camera_zoom = 2.1
	camera_follow = true
	_clamp_camera()
	touch_points.clear()
	touch_starts.clear()
	touch_moved.clear()
	mouse_down = false
	pulse = 0.0
	save_clock = 0.0
	team_notice_clock = 0.0
	last_team_payout = 0
	message = "Kurye ilk siparişe gidiyor!"
	message_clock = 5.0
	has_started = false
	district_panel.visible = false
	settings_overlay.visible = false
	menu_overlay.visible = true
	menu_start_button.text = "OYUNA BAŞLA"
	_seed_founder_job()
	_route_to_mission()
	_refresh_ui()
	_save_game()
	queue_redraw()

func _build_district_panel() -> void:
	district_panel = FRAMED_PANEL.instantiate()
	district_panel.size = Vector2(448, 610)
	add_child(district_panel)
	_label(Vector2(16, 12), Vector2(350, 30), 21, Color("f9b553"), district_panel).text = "İSTANBUL • İLÇELER"
	_button(Vector2(390, 10), Vector2(42, 38), _toggle_district_panel, district_panel).text = "X"
	for i in DISTRICTS.size():
		var select := _button(Vector2(16 + (i % 4) * 104, 58 + (i / 4) * 50), Vector2(98, 44), _select_district.bind(i), district_panel)
		select.add_theme_font_size_override("font_size", 12)
		district_select_buttons.append(select)
	district_name_label = _label(Vector2(16, 160), Vector2(416, 30), 21, Color("ffcf71"), district_panel)
	district_postcard = TextureRect.new()
	district_postcard.position = Vector2(16, 200)
	district_postcard.size = Vector2(164, 120)
	district_postcard.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	district_postcard.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	district_postcard.mouse_filter = Control.MOUSE_FILTER_IGNORE
	district_panel.add_child(district_postcard)
	district_comparison = _label(Vector2(192, 198), Vector2(240, 124), 13, Color("fff0d1"), district_panel)
	district_progress_label = _label(Vector2(16, 330), Vector2(416, 46), 12, Color("b9d8d3"), district_panel)
	district_progress_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	district_progress_bar = ProgressBar.new()
	district_progress_bar.position = Vector2(16, 381)
	district_progress_bar.size = Vector2(416, 8)
	district_progress_bar.show_percentage = false
	district_progress_bar.add_theme_stylebox_override("background", _progress_style(Color("27495b")))
	district_progress_bar.add_theme_stylebox_override("fill", _progress_style(Color("70dfcf")))
	district_panel.add_child(district_progress_bar)
	district_activate_button = _button(Vector2(16, 399), Vector2(416, 44), _activate_selected_district, district_panel)
	_primary_button(district_activate_button)
	album_button = _button(Vector2(16, 453), Vector2(416, 38), _toggle_album, district_panel)
	album_button.add_theme_font_size_override("font_size", 14)
	district_bonus_label = _label(Vector2(16, 497), Vector2(416, 24), 13, Color("ffcf71"), district_panel)
	rebirth_button = _button(Vector2(16, 526), Vector2(416, 42), _confirm_rebirth, district_panel)
	rebirth_button.add_theme_font_size_override("font_size", 13)
	_label(Vector2(16, 575), Vector2(416, 24), 11, Color("a6b9c5"), district_panel).text = "Yeni turda işletme sıfırlanır; toplam ciro ve albüm kalır."
	_build_album()
	district_panel.visible = false
	rebirth_dialog = ConfirmationDialog.new()
	rebirth_dialog.title = "İstanbul İtibarı • Yeni Şirket Turu"
	rebirth_dialog.dialog_text = "İstanbul İtibarı ve yeni tur önizlemesi"
	rebirth_dialog.ok_button_text = "YENİ TUR"
	rebirth_dialog.cancel_button_text = "VAZGEÇ"
	_style_confirmation(rebirth_dialog, false)
	rebirth_dialog.min_size = Vector2i(440, 500)
	rebirth_dialog.get_label().add_theme_font_size_override("font_size", 15)
	specialization_choice = OptionButton.new()
	specialization_choice.custom_minimum_size = Vector2(400, 44)
	specialization_choice.hide()
	for title in Specialization.TITLES: specialization_choice.add_item(title)
	specialization_choice.item_selected.connect(_select_specialization)
	add_child(specialization_choice)
	rebirth_dialog.add_button("MODEL SEÇ", true, "model")
	rebirth_dialog.custom_action.connect(_show_specialization_menu)
	rebirth_dialog.confirmed.connect(_rebirth)
	add_child(rebirth_dialog)
	model_menu = preload("res://scripts/specialization_picker.gd").new()
	rebirth_dialog.add_child(model_menu)
	model_menu.build(self)
	rebirth_dialog.borderless = true
	prestige_shade = ColorRect.new()
	prestige_shade.color = Color("06121cd9")
	prestige_shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	prestige_shade.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(prestige_shade)
	prestige_shade.hide()
	rebirth_dialog.visibility_changed.connect(func() -> void: prestige_shade.visible = rebirth_dialog.visible)



func _label(pos: Vector2, size: Vector2, font_size: int, color: Color, parent: Control = null) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	if parent == null:
		add_child(label)
	else:
		parent.add_child(label)
	return label

func _button(pos: Vector2, size: Vector2, callback: Callable, parent: Control = null) -> Button:
	var button := Button.new()
	button.position = pos
	button.size = size
	button.add_theme_font_size_override("font_size", 16)
	button.pressed.connect(callback)
	if parent == null:
		add_child(button)
	else:
		parent.add_child(button)
	return button

func _primary_button(button: Button) -> void:
	button.add_theme_color_override("font_color", Color("102536"))
	button.add_theme_color_override("font_hover_color", Color("102536"))
	button.add_theme_color_override("font_pressed_color", Color("102536"))
	button.add_theme_color_override("font_focus_color", Color("102536"))
	button.add_theme_stylebox_override("normal", _button_style(Color("f9b553"), Color("ffd78d")))
	button.add_theme_stylebox_override("hover", _button_style(Color("ffc978"), Color("fff0d1")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("d88a31"), Color("fff0d1")))

func _style_confirmation(dialog: ConfirmationDialog, destructive: bool) -> void:
	dialog.dialog_autowrap = true
	dialog.min_size = Vector2i(400, 180)
	dialog.add_theme_stylebox_override("panel", _button_style(Color("071d2c"), Color("f9b553")))
	dialog.add_theme_constant_override("buttons_min_height", 42)
	dialog.add_theme_constant_override("buttons_min_width", 130)
	dialog.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialog.get_label().add_theme_color_override("font_color", Color("fff0d1"))
	if destructive:
		dialog.get_ok_button().add_theme_stylebox_override("normal", _button_style(Color("873c38"), Color("e48a70")))
	else:
		_primary_button(dialog.get_ok_button())

func _button_style(fill: Color, outline: Color) -> StyleBox:
	var style := PixelStyle.new()
	style.fill = fill
	style.outline = outline
	style.set_content_margin_all(5)
	return style


func _progress_style(fill: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.set_corner_radius_all(0)
	style.set_content_margin_all(0)
	return style

func _bottom_top() -> float:
	return maxf(MAP_TOP + 240.0, size.y - BOTTOM_HEIGHT)

func _map_rect() -> Rect2:
	return Rect2(0, MAP_TOP, size.x, _bottom_top() - MAP_TOP)

func _layout_ui() -> void:
	if menu_overlay == null:
		return
	var bottom := _bottom_top()
	if return_panel != null:
		return_panel.position = (size - return_panel.size) * 0.5
	district_panel.position = (size - district_panel.size) * 0.5
	menu_title.position = Vector2((size.x - menu_title.size.x) * 0.5, size.y * 0.07)
	menu_subtitle.position = Vector2((size.x - menu_subtitle.size.x) * 0.5, size.y * 0.07 + 112)
	menu_start_button.position = Vector2((size.x - menu_start_button.size.x) * 0.5, size.y - 155)
	menu_settings_button.position = Vector2((size.x - menu_settings_button.size.x) * 0.5, size.y - 87)
	settings_panel.position = (size - settings_panel.size) * 0.5
	location_panel.position = Vector2((size.x - location_panel.size.x) * 0.5, _bottom_top() - location_panel.size.y - 10)
	_clamp_camera()
	queue_redraw()

func _minimum_zoom() -> float:
	var view := _map_rect().size
	var bounds := _camera_bounds()
	return maxf(1.0, maxf(view.x / bounds.size.x, view.y / bounds.size.y))

func _camera_bounds() -> Rect2:
	return SILE_VIEW_BOUNDS if district_index == 0 else WORLD_BOUNDS

func _clamp_camera() -> void:
	camera_zoom = clampf(camera_zoom, _minimum_zoom(), MAX_MAP_ZOOM)
	var half := _map_rect().size / (2.0 * camera_zoom)
	var bounds := _camera_bounds()
	var middle := bounds.get_center()
	camera_center.x = middle.x if half.x >= bounds.size.x * 0.5 else clampf(camera_center.x, bounds.position.x + half.x, bounds.end.x - half.x)
	camera_center.y = middle.y if half.y >= bounds.size.y * 0.5 else clampf(camera_center.y, bounds.position.y + half.y, bounds.end.y - half.y)

func _world_to_screen(point: Vector2) -> Vector2:
	var offset := Iso.project(point - camera_center) if district_index == 0 else point - camera_center
	return _map_rect().get_center() + offset * camera_zoom

func _screen_to_world(point: Vector2) -> Vector2:
	var offset := (point - _map_rect().get_center()) / camera_zoom
	return camera_center + (Iso.unproject(offset) if district_index == 0 else offset)

func _zoom_at(screen_point: Vector2, desired_zoom: float) -> void:
	var anchor := _screen_to_world(screen_point)
	camera_follow = false
	camera_zoom = clampf(desired_zoom, _minimum_zoom(), MAX_MAP_ZOOM)
	var offset := (screen_point - _map_rect().get_center()) / camera_zoom
	camera_center = anchor - (Iso.unproject(offset) if district_index == 0 else offset)
	_clamp_camera()
	queue_redraw()

func _change_zoom(factor: float) -> void:
	_zoom_at(_map_rect().get_center(), camera_zoom * factor)

func _center_on_player() -> void:
	camera_follow = true
	camera_center = player + Vector2(0, 55 if district_index == 0 else 0)
	_clamp_camera()
	queue_redraw()

func _map_input_allowed(point: Vector2) -> bool:
	return _map_actions_allowed() and _map_rect().has_point(point) and point.y > 155.0 and not (location_panel.visible and location_panel.get_rect().has_point(point)) and not (guide_panel.visible and guide_panel.get_rect().has_point(point))

func _map_actions_allowed() -> bool:
	if company_ui != null and company_ui.blocks_map(): return false
	return not migration_dialog.visible and not return_overlay.visible and not menu_overlay.visible and not settings_overlay.visible and not district_panel.visible and not reset_dialog.visible and not rebirth_dialog.visible

func _process(delta: float) -> void:
	if application_suspended:
		return
	if (menu_overlay != null and menu_overlay.visible) or (settings_overlay != null and settings_overlay.visible):
		return
	pulse += delta
	save_clock += delta
	var should_save := save_clock >= 30.0
	if should_save:
		save_clock = 0.0
	if message_clock > 0.0:
		message_clock -= delta
	if team_notice_clock > 0.0:
		team_notice_clock -= delta
	var previous_open := unlocked_district_index
	var previous_finished: int = dispatch.completed + dispatch.founder_completed
	var report := _advance_simulation(delta)
	if is_instance_valid(feedback):
		feedback.deliveries(int(report["solo"]) + int(report["team"]), dispatch.completed + dispatch.founder_completed - previous_finished)
		if unlocked_district_index > previous_open:
			feedback.milestone("%s açıldı • İlçe ekranından seç" % DISTRICTS[unlocked_district_index])
	# Purchases, district changes and lifecycle events still checkpoint directly.
	# Ordinary completions are persisted together at the 30-second checkpoint.
	if should_save:
		_save_game()
	var animation_frame := int(pulse * 2.0)
	if animation_frame != last_map_animation_frame:
		last_map_animation_frame = animation_frame
		_refresh_ui()
		queue_redraw()

func _location_screen_position(index: int) -> Vector2:
	return map_view.location_position(index)

func _select_map_location(position: Vector2) -> bool:
	if not _map_input_allowed(position):
		return false
	for i in LOCATION_POSITIONS.size():
		var center := _location_screen_position(i)
		if Rect2(center - Vector2(22, 22), Vector2(44, 44)).has_point(position):
			selected_location = i
			_refresh_location_card()
			location_panel.visible = true
			queue_redraw()
			return true
	_close_location_card()
	return false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _map_input_allowed(event.position):
			touch_starts[event.index] = event.position
			touch_moved[event.index] = false
			if touch_starts.size() > 1:
				for key in touch_moved:
					touch_moved[key] = true
			accept_event()
		elif not event.pressed and touch_starts.has(event.index):
			if not event.canceled and not bool(touch_moved[event.index]) and event.position.distance_to(touch_starts[event.index]) <= 8.0 and _map_input_allowed(event.position):
				_select_map_location(event.position)
			touch_starts.erase(event.index)
			touch_moved.erase(event.index)
			accept_event()
	elif event is InputEventScreenDrag and touch_starts.has(event.index):
		if event.position.distance_to(touch_starts[event.index]) > 8.0:
			touch_moved[event.index] = true
		accept_event()
	elif event is InputEventMouseButton and not OS.has_feature("mobile") and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _map_input_allowed(event.position):
			mouse_down = true
			mouse_start = event.position
			mouse_dragged = false
			accept_event()
		elif not event.pressed and mouse_down:
			if not mouse_dragged and event.position.distance_to(mouse_start) <= 8.0 and _map_input_allowed(event.position):
				_select_map_location(event.position)
			mouse_down = false
			accept_event()
	elif event is InputEventMouseMotion and mouse_down and not OS.has_feature("mobile"):
		if event.position.distance_to(mouse_start) > 8.0:
			mouse_dragged = true
		accept_event()

func _route_to_mission() -> void:
	var destination: Vector2 = _drop_position(drop_index) if carrying else _pickup_position(pickup_index)
	waypoints = roads.route_between(player, destination)
	_reset_delivery_progress()

func _remaining_phase_distance() -> float:
	var distance := 0.0
	var previous := player
	var destination := _drop_position(drop_index) if carrying else _pickup_position(pickup_index)
	if waypoints.is_empty():
		return _route_length(player, destination)
	for point in waypoints:
		distance += previous.distance_to(point)
		previous = point
	if previous.distance_to(destination) > 0.01:
		distance += _route_length(previous, destination)
	return distance

func _reset_delivery_progress() -> void:
	phase_start_distance = maxf(_remaining_phase_distance(), 1.0)

func _sync_founder_state() -> void:
	var job := _focus_job()
	if job.is_empty():
		carrying = false
		return
	pickup_index = int(job["pickup"])
	drop_index = int(job["drop"])
	order_payout = int(job.get("founder_base", job["payout"]))
	carrying = float(job["duration"]) - float(job["remaining"]) >= float(job.get("pickup_seconds", 20.0)) - Dispatch.EPS

func _seed_founder_job(preserve_legacy: bool = false) -> void:
	if simulation_economy_version >= 6:
		simulation_initialized = true
		if brand_ready: _seed_company_job()
		return
	if not _focus_job().is_empty():
		return
	var job := _order_quote(pickup_index, drop_index)
	if preserve_legacy:
		job["payout"] = order_payout
		job["founder_base"] = order_payout
		job["paid"] = int(round(order_payout * _income_multiplier()))
		job["founder_paid"] = job["paid"]
		job["work_distance"] = job["distance"]
		job["speed_profile"] = Economy.LEGACY_ROLE_SPEED
		job["handoff_seconds"] = 20.0
		job.erase("pickup_share")
	job.merge({"role": Dispatch.FOUNDER, "slot": 0, "origin": -1})
	var speeds: Array = job["speed_profile"]
	job["duration"] = float(job["handoff_seconds"]) + float(job["work_distance"]) / float(speeds[vehicle]) * (1.0 + district_index * 0.08)
	job["pickup_seconds"] = float(job["duration"]) * float(job.get("pickup_share", 0.0)) if not preserve_legacy else 20.0
	job["remaining"] = float(job["duration"]) - (float(job["pickup_seconds"]) if carrying else 0.0)
	dispatch.active.append(job)
	simulation_initialized = true

func _calculate_payout(from_index: int, to_index: int) -> int:
	var distance := _route_length(_pickup_position(from_index), _drop_position(to_index))
	if simulation_economy_version < 2:
		return 30 + int(distance / 25.0) + vehicle * 12
	return int(round(12.0 + 8.0 * distance / float(_market_profile()["mean_distance"])))

func _order_quote(from_index: int, to_index: int) -> Dictionary:
	var distance := _route_length(_pickup_position(from_index), _drop_position(to_index))
	if simulation_economy_version < 2:
		var base := 30 + int(distance / 25.0)
		return {"pickup": from_index, "drop": to_index, "distance": distance, "payout": base, "founder_base": base + vehicle * 12, "district": district_index, "paid": int(round(base * _income_multiplier())), "founder_paid": int(round((base + vehicle * 12) * _income_multiplier())), "work_distance": distance, "handoff_seconds": 20.0, "speed_profile": Economy.LEGACY_ROLE_SPEED}
	var base := _calculate_payout(from_index, to_index)
	var paid := int(round(base * Economy.service_multiplier(service_level) * _income_multiplier()))
	return {"pickup": from_index, "drop": to_index, "district": district_index, "distance": distance, "work_distance": distance / float(_market_profile()["mean_distance"]) * (Economy.DISTRICT_DISTANCE[district_index] if simulation_economy_version >= 3 else Economy.REFERENCE_DISTANCE), "payout": base, "founder_base": base, "paid": paid, "founder_paid": paid, "speed_profile": _company_speeds(), "handoff_seconds": 0.0, "pickup_share": Economy.PICKUP_SHARE}

func _route_length(start: Vector2, finish: Vector2) -> float:
	var key := Vector4(start.x, start.y, finish.x, finish.y)
	if not route_distance_cache.has(key):
		route_distance_cache[key] = _network_distance(roads, start, finish)
	return float(route_distance_cache[key])

func _network_distance(network: RefCounted, start: Vector2, finish: Vector2) -> float:
	var path: Array = network.route_between(start, finish)
	var length := 0.0
	var previous := start
	for point in path:
		length += previous.distance_to(point)
		previous = point
	return length

func _make_company_order() -> Dictionary:
	var from_index := rng.randi_range(0, PICKUPS.size() - 1)
	var to_index := rng.randi_range(0, DROPS.size() - 1)
	while _pickup_position(from_index) == _drop_position(to_index):
		to_index = (to_index + 1) % DROPS.size()
	return _order_quote(from_index, to_index)

func _advance_simulation(delta: float) -> Dictionary:
	var stars_before := motivation_stars
	advance_report = {"solo": 0, "team": 0, "completed": 0, "stars": 0}
	var counts: Array[int] = [0, 0, 0, 0]
	if company:
		counts = staff_counts
	dispatch.advance(delta, counts, district_index, _make_company_order, -1 if simulation_economy_version >= 6 else vehicle, _on_order_finished, func() -> int: return district_index, Economy.LEGACY_DEMAND if simulation_economy_version < 2 else [], local_metrics.advance)
	_sync_founder_state()
	advance_report["stars"] = motivation_stars - stars_before
	return advance_report.duplicate()

func _on_order_finished(job: Dictionary) -> void:
	var founder := int(job["role"]) == Dispatch.FOUNDER
	var paid := int(job.get("founder_paid" if founder else "paid", job["payout"]))
	lifetime_deliveries += 1
	star_progress += 1
	if star_progress >= 100:
		motivation_stars += star_progress / 100
		star_progress %= 100
	money += paid
	total_earned += paid
	run_earned += paid
	advance_report["solo" if founder else "team"] += paid
	if founder:
		deliveries += 1
	else:
		advance_report["completed"] += 1
		last_team_payout = paid
		team_notice_clock = 3.0
	_maybe_unlock_team()
	_update_district()

func _advance_dispatch(delta: float, persist: bool = true) -> int:
	var report := _advance_simulation(delta)
	if persist:
		_save_game()
		_refresh_ui()
	return int(report["solo"]) + int(report["team"])

func _income_multiplier() -> float:
	return (1.0 + district_index * 0.25) * _motivation_multiplier() * Economy.reputation_multiplier(rebirth_count, simulation_economy_version) * (1.0 + bonus_level * 0.05 if simulation_economy_version >= 6 else 1.0)

func _credit(base_amount: int) -> int:
	var paid := int(round(base_amount * _income_multiplier()))
	money += paid
	total_earned += paid
	run_earned += paid
	_update_district()
	return paid

func _update_district() -> void:
	if simulation_economy_version < 3:
		# Settle pre-A6 absence with its original automatic district progression.
		var previous := district_index
		while district_index + 1 < DISTRICTS.size() and run_earned >= Economy.LEGACY_DISTRICT_THRESHOLDS[district_index + 1]:
			district_index += 1
		if previous != district_index:
			_build_roads()
			player = _district_spawn()
			camera_center = player + Vector2(0, 55 if district_index == 0 else 0)
		unlocked_district_index = maxi(unlocked_district_index, district_index)
		return
	var previous := unlocked_district_index
	var thresholds: Array = Economy.A6_DISTRICT_THRESHOLDS if simulation_economy_version < 5 else DISTRICT_THRESHOLDS
	while unlocked_district_index + 1 < DISTRICTS.size() and run_earned >= thresholds[unlocked_district_index + 1]:
		unlocked_district_index += 1
	if previous != unlocked_district_index:
		local_metrics.record("district_unlocked", {"district": unlocked_district_index, "revenue": run_earned})
		message = "%s açıldı • İlçe ekranından seçebilirsin" % DISTRICTS[unlocked_district_index]
		message_clock = 6.0

func _activate_district(index: int) -> void:
	if index < 0 or index > unlocked_district_index or index >= DISTRICTS.size(): return
	if index == district_index: return
	_close_location_card()
	var arrival_fraction := clampf(dispatch.arrival_elapsed / (60.0 / float(Economy.DEMAND_PER_MINUTE[district_index])), 0.0, 1.0)
	district_index = index
	dispatch.arrival_elapsed = arrival_fraction * (60.0 / float(Economy.DEMAND_PER_MINUTE[index]))
	district_selection = index
	_build_roads()
	player = _district_spawn()
	camera_center = player + Vector2(0, 55 if index == 0 else 0)
	camera_follow = true
	# Keep fractional arrival progress; switching repeatedly cannot spawn free orders.
	dispatch.staff_locations.clear()
	_collect_district(index)
	local_metrics.record("district_selected", {"district": index, "revenue": run_earned})
	_sync_founder_state()
	_announce("%s etkin • Eski işler kendi koşullarıyla tamamlanır" % DISTRICTS[index])
	_save_game()
	_refresh_ui()

func _collect_district(index: int) -> void:
	if not album_unlocked.has(index): album_unlocked.append(index)


func _toggle_district_panel() -> void:
	_close_location_card()
	district_panel.visible = not district_panel.visible
	if district_panel.visible:
		district_selection = district_index
		album_panel.hide()
	_refresh_ui()

func _rebirth_ready() -> bool:
	return unlocked_district_index == DISTRICTS.size() - 1 and run_earned >= run_prestige_target

func _select_specialization(index: int) -> void:
	specialization_choice.select(index)
	_refresh_prestige_preview()

func _show_specialization_menu(_action: StringName) -> void:
	model_menu.open()

func _confirm_rebirth() -> void:
	specialization_choice.select(Specialization.IDS.find(specialization_id))
	guide_panel.hide()
	album_panel.hide()
	_close_location_card()
	_refresh_prestige_preview()
	rebirth_dialog.popup_centered(Vector2i(440, 520))

func _refresh_prestige_preview() -> void:
	var candidate := _prepare_rebirth_record()
	var job: Dictionary = candidate["dispatch"]["active"][0]
	var before := int(round(int(job["payout"]) * Economy.reputation_multiplier(rebirth_count) * _motivation_multiplier()))
	var after := int(job["paid"])
	var requirement := "HAZIR • +1 itibar kazanabilirsin"
	if not _rebirth_ready():
		requirement = "Beyoğlu açık + %s ₺ tur cirosu gerekli.\nTur: %s ₺ • Kalan: %s ₺" % [Numbers.compact(run_prestige_target), Numbers.compact(run_earned), Numbers.compact(maxi(0, run_prestige_target - run_earned))]
	if not save_store.writable: requirement = "Kayıt yazılamıyor; yeni tur başlatılamaz."
	rebirth_dialog.dialog_text = "İSTANBUL İTİBARI  %d → %d\nKALICI KAZANÇ  +%d%% → +%d%%\n\nAynı Şile işi: %s → %s ₺\nYaya, hizmet 0; her tur +25 yüzde puan.\n\nYENİDEN KURULUR\nKasa, filo ve tur içi yükseltmeler.\nBekleyen işler yeni tura taşınmaz.\n\nKORUNUR\nŞirket adı/logosu, itibar ve rehber.\nMotivasyon seviyesi ve yıldızlar.\nYeni tur ödülü: +10 yıldız.\nToplam ciro: %s ₺ • Albüm: %d/7\n\nYeni tur: Şile • 1 yaya • 60 ₺\nBaşlangıç sermayesi ciro sayılmaz.\n\n%s" % [rebirth_count, rebirth_count + 1, rebirth_count * 25, (rebirth_count + 1) * 25, Numbers.compact(before), Numbers.compact(after), Numbers.compact(total_earned), album_unlocked.size(), requirement]
	rebirth_dialog.dialog_text += "\n\nYeni tur modeli: " + Specialization.TITLES[specialization_choice.selected] + "\n" + Specialization.DETAILS[specialization_choice.selected] + "\nSonraki itibarda ücretsiz değiştirilebilir." 
	rebirth_dialog.get_ok_button().disabled = not _rebirth_ready() or not save_store.writable

func _prepare_rebirth_record() -> Dictionary:
	# Prepare a complete new run without touching the current game or RNG.
	var data := _save_data().duplicate(true)
	var network := RoadNetwork.new()
	for point in sile_map["nodes"]: network.add_node(Vector2(float(point[0]), float(point[1])))
	for edge in sile_map["edges"]: network.connect_nodes(int(edge[0]), int(edge[1]))
	var start: Vector2 = network.nodes[int(sile_map["pickup_nodes"][0])]
	var finish: Vector2 = network.nodes[int(sile_map["drop_nodes"][0])]
	var distance := _network_distance(network, start, finish)
	var normalized := distance / float(_market_profile(0)["mean_distance"]) * Economy.DISTRICT_DISTANCE[0]
	var base := int(round(12.0 + 8.0 * distance / float(_market_profile(0)["mean_distance"])))
	var paid := int(round(base * Economy.reputation_multiplier(rebirth_count + 1) * _motivation_multiplier()))
	var chosen: String = Specialization.IDS[specialization_choice.selected]
	data["specialization_id"] = chosen
	data["motivation_stars"] = motivation_stars + 10
	var starter_speeds: Array = Specialization.apply(Economy.company_speeds(0, 0, 0), chosen)
	var duration := normalized / float(starter_speeds[0])
	var new_dispatch := Dispatch.new()
	new_dispatch.active.append({"pickup": 0, "drop": 0, "district": 0, "distance": distance, "work_distance": normalized, "payout": base, "founder_base": base, "paid": paid, "founder_paid": paid, "speed_profile": starter_speeds, "handoff_seconds": 0.0, "pickup_share": Economy.PICKUP_SHARE, "role": 0 if simulation_economy_version >= 6 else Dispatch.FOUNDER, "slot": 0, "origin": -1, "duration": duration, "pickup_seconds": duration * Economy.PICKUP_SHARE, "remaining": duration})
	var spawn: Vector2 = network.nodes[int(sile_map["spawn_node"])]+ Vector2(0, 55)
	var next_metrics := LocalMetrics.new()
	next_metrics.restore(local_metrics.to_save())
	next_metrics.record("prestige", {"before": rebirth_count, "after": rebirth_count + 1, "revenue": run_earned})
	next_metrics.next_run()
	next_metrics.record("automation_started", {"reputation": rebirth_count + 1}, true)
	data["local_metrics"] = next_metrics.to_save()
	data.merge({"economy_version": Economy.VERSION, "run_prestige_target": Economy.REBIRTH_THRESHOLD, "legacy_speed_floor": [], "rebirth_count": rebirth_count + 1, "money": Economy.STARTING_CASH, "service_level": 0, "run_earned": 0, "deliveries": 0, "district_index": 0, "unlocked_district_index": 0, "vehicle": 0, "company": simulation_economy_version >= 6, "workers": 1 if simulation_economy_version >= 6 else 0, "staff_counts": [1, 0, 0, 0] if simulation_economy_version >= 6 else [0, 0, 0, 0], "bonus_level": 0, "operations_level": 0, "comfort_level": 0, "starter_role": 0, "dispatch": new_dispatch.to_save(), "pickup_index": 0, "drop_index": 0, "order_payout": base, "carrying": false, "camera_center": [spawn.x, spawn.y], "camera_zoom": 2.1, "camera_follow": true, "return_summary": {}, "migration_notice": "", "last_saved_at": maxi(last_saved_at, int(Time.get_unix_time_from_system()))}, true)
	return data


func _rebirth() -> void:
	if not _rebirth_ready():
		return
	var candidate := _prepare_rebirth_record()
	if not save_store.write_record(SAVE_PATH, candidate):
		_announce("Yeni tur kaydedilemedi • İşletmen korundu, tekrar deneyebilirsin")
		return
	last_saved_at = int(candidate["last_saved_at"])
	local_metrics.restore(candidate["local_metrics"])
	return_summary.clear()
	migration_notice = ""
	return_overlay.hide()
	album_panel.hide()
	rebirth_dialog.hide()
	_close_location_card()
	motivation_stars = int(candidate["motivation_stars"])
	specialization_id = str(candidate["specialization_id"])
	rebirth_count += 1
	run_earned = 0
	district_index = 0
	unlocked_district_index = 0
	district_selection = 0
	_build_roads()
	money = Economy.STARTING_CASH
	service_level = 0
	deliveries = 0
	vehicle = 0
	bonus_level = 0
	operations_level = 0
	comfort_level = 0
	run_prestige_target = Economy.REBIRTH_THRESHOLD
	legacy_speed_floor = []
	starter_role = 0
	company = simulation_economy_version >= 6
	workers = 1 if company else 0
	staff_counts.assign([1, 0, 0, 0] if company else [0, 0, 0, 0])
	if company_ui != null: company_ui.close_all()
	dispatch.reset()
	team_notice_clock = 0.0
	last_team_payout = 0
	camera_center = _district_spawn() + Vector2(0, 55)
	camera_zoom = 2.1
	camera_follow = true
	_clamp_camera()
	carrying = false
	player = _district_spawn()
	pickup_index = 0
	drop_index = 0
	order_payout = _calculate_payout(pickup_index, drop_index)
	district_panel.visible = false
	_seed_founder_job()
	_route_to_mission()
	_announce("İstanbul İtibarı %d • Kalıcı kazanç +%d%%" % [rebirth_count, rebirth_count * 25])
	if is_instance_valid(feedback): feedback.milestone("İstanbul İtibarı %d • Yeni tur hazır" % rebirth_count)
	_refresh_ui()
	queue_redraw()

func _buy_vehicle() -> void:
	if simulation_economy_version >= 6:
		company_ui.open_tab(4)
		return
	if vehicle >= 3:
		return
	var cost: int = COSTS[vehicle + 1]
	if money < cost:
		_announce("Bu araç için %s ₺ gerekli." % Numbers.compact(cost))
		return
	money -= cost
	vehicle += 1
	_track_investment("vehicle", cost, vehicle)
	_announce("%s: yeni işler daha hızlı • Aktif iş korunur" % VEHICLES[vehicle])
	_save_game()
	_refresh_ui()
	queue_redraw()

func _buy_service() -> void:
	if service_level >= Economy.MAX_SERVICE_LEVEL:
		return
	var cost := Economy.service_cost(service_level)
	if money < cost:
		return
	money -= cost
	service_level += 1
	_track_investment("service", cost, service_level)
	_announce("Hizmet %d: ücret çarpanı ×%s • Yeni işler için" % [service_level, _rate(Economy.service_multiplier(service_level))])
	_save_game()

func _maybe_unlock_team() -> void:
	if simulation_economy_version >= 2 and simulation_economy_version < 6 and not company and deliveries + dispatch.completed >= 5:
		company = true
		local_metrics.record("team_unlocked", {"deliveries": deliveries + dispatch.completed}, true)
		message = "Ekip yönetimi açıldı • İlk çalışanını seçebilirsin"
		message_clock = 5.0

func _toggle_company_panel() -> void:
	if company_ui != null: company_ui.open_tab(4)

func _staff_cost(role: int) -> int:
	return Economy.hire_cost(role, maxi(0, staff_counts[role] - (1 if simulation_economy_version >= 6 and role == starter_role else 0)), simulation_economy_version)

func _hire_worker(role: int) -> void:
	if not company:
		_announce("Önce şirket kurmalısın.")
		return
	var cost := _staff_cost(role)
	if money < cost:
		_announce("%s kurye için %s ₺ gerekli." % [STAFF_NAMES[role], Numbers.compact(cost)])
		return
	money -= cost
	staff_counts[role] += 1
	workers += 1
	_track_investment("worker", cost, role)
	local_metrics.record("first_staff", {"role": role, "reputation": rebirth_count}, true)
	_announce("%s kurye işe başladı!" % STAFF_NAMES[role])
	_advance_dispatch(0.0)
	_save_game()
	_refresh_ui()

func _announce(text: String) -> void:
	message = text
	message_clock = 4.0
	_refresh_ui()

func _refresh_ui() -> void:
	queue_redraw()
	_sync_founder_state()
	_refresh_location_card()
	hud.refresh()
	_refresh_guide()
	_refresh_district_panel()
	district_bonus_label.text = "İstanbul İtibarı: %d  •  Kalıcı kazanç +%d%%" % [rebirth_count, rebirth_count * 25]
	rebirth_button.text = "İSTANBUL İTİBARI • YENİ TURU İNCELE"
	rebirth_button.disabled = false
	if rebirth_dialog.visible: _refresh_prestige_preview()
	if return_overlay != null and return_overlay.visible: _refresh_return_choices()
	if company_ui != null: company_ui.sync()

func _save_data() -> Dictionary:
	return {"lifetime_deliveries": lifetime_deliveries, "achievement_claimed": achievement_claimed.duplicate(), "motivation_stars": motivation_stars, "motivation_level": motivation_level, "star_progress": star_progress, "specialization_id": specialization_id, "feedback_settings": {"sound": sound_enabled, "haptics": haptics_enabled}, "economy_version": Economy.VERSION, "run_prestige_target": run_prestige_target, "legacy_speed_floor": legacy_speed_floor, "company_name": company_name, "company_logo": company_logo, "brand_ready": brand_ready, "bonus_level": bonus_level, "operations_level": operations_level, "comfort_level": comfort_level, "starter_role": starter_role, "local_metrics": local_metrics.to_save(), "guide_seen": guide_seen, "service_level": service_level, "migration_notice": migration_notice, "rng_state": str(rng.state), "return_summary": return_summary, "started": has_started, "money": money, "total_earned": total_earned, "run_earned": run_earned, "district_index": district_index, "unlocked_district_index": unlocked_district_index, "album_unlocked": album_unlocked, "rebirth_count": rebirth_count, "deliveries": deliveries, "vehicle": vehicle, "company": company, "workers": workers, "staff_counts": staff_counts, "dispatch": dispatch.to_save(), "pickup_index": pickup_index, "drop_index": drop_index, "order_payout": order_payout, "carrying": carrying, "camera_center": [camera_center.x, camera_center.y], "camera_zoom": camera_zoom, "camera_follow": camera_follow, "last_saved_at": last_saved_at}

func _save_game() -> void:
	_settle_settings_time()
	last_saved_at = maxi(last_saved_at, int(Time.get_unix_time_from_system()))
	if not save_store.write_record(SAVE_PATH, _save_data()):
		push_error("Game save could not be committed; previous record retained")


func _load_game() -> void:
	var data := save_store.load_record(SAVE_PATH)
	if data.is_empty():
		return
	motivation_stars = clampi(int(data.get("motivation_stars", 0)), 0, 1000000000)
	motivation_level = clampi(int(data.get("motivation_level", 0)), 0, 20)
	star_progress = clampi(int(data.get("star_progress", 0)), 0, 99)
	var saved_feedback = data.get("feedback_settings", {})
	if saved_feedback is Dictionary:
		sound_enabled = bool(saved_feedback.get("sound", false))
		haptics_enabled = bool(saved_feedback.get("haptics", false))
	simulation_economy_version = int(data.get("economy_version", 0))
	run_prestige_target = maxi(1, int(data.get("run_prestige_target", Economy.LEGACY_REBIRTH_THRESHOLD if simulation_economy_version < 7 else Economy.REBIRTH_THRESHOLD)))
	legacy_speed_floor = []
	var saved_floor = data.get("legacy_speed_floor", [])
	if saved_floor is Array and saved_floor.size() == 4:
		for value in saved_floor: legacy_speed_floor.append(clampf(float(value), 0.0, 1000000.0))
	local_metrics.restore(data.get("local_metrics", null))
	company_name = str(data.get("company_name", "")).strip_edges().left(24)
	company_logo = clampi(int(data.get("company_logo", 0)), 0, 8)
	brand_ready = bool(data.get("brand_ready", false)) and company_name.length() >= 2
	bonus_level = clampi(int(data.get("bonus_level", 0)), 0, 20)
	operations_level = clampi(int(data.get("operations_level", 0)), 0, 20)
	comfort_level = clampi(int(data.get("comfort_level", 0)), 0, 20)
	starter_role = clampi(int(data.get("starter_role", 0)), 0, 3)
	service_level = clampi(int(data.get("service_level", 0)), 0, Economy.MAX_SERVICE_LEVEL)
	migration_notice = str(data.get("migration_notice", ""))
	guide_seen = bool(data.get("guide_seen", true))
	var saved_summary = data.get("return_summary", {})
	if saved_summary is Dictionary:
		for key in ["seconds", "solo", "team", "completed", "capped", "stars"]:
			return_summary[key] = maxi(0, int(saved_summary.get(key, 0)))
	has_started = bool(data.get("started", true))
	money = max(0, int(data.get("money", 0)))
	total_earned = max(0, int(data.get("total_earned", 0)))
	run_earned = max(0, int(data.get("run_earned", total_earned)))
	district_index = clampi(int(data.get("district_index", 0)), 0, DISTRICTS.size() - 1)
	_build_roads()
	unlocked_district_index = clampi(maxi(district_index, int(data.get("unlocked_district_index", district_index))), 0, DISTRICTS.size() - 1)
	album_unlocked.clear()
	for index in data.get("album_unlocked", []):
		if int(index) >= 0 and int(index) < DISTRICTS.size() and not album_unlocked.has(int(index)): album_unlocked.append(int(index))
	_collect_district(0)
	rebirth_count = max(0, int(data.get("rebirth_count", 0)))
	specialization_id = Specialization.valid(data.get("specialization_id", "standard")) if rebirth_count > 0 else "standard"
	_update_district()
	deliveries = max(0, int(data.get("deliveries", 0)))
	vehicle = clampi(int(data.get("vehicle", 0)), 0, 3)
	company = bool(data.get("company", false))
	var saved_staff = data.get("staff_counts", null)
	if saved_staff is Array and saved_staff.size() == STAFF_NAMES.size():
		for i in STAFF_NAMES.size():
			staff_counts[i] = max(0, int(saved_staff[i]))
	else:
		staff_counts[0] = max(0, int(data.get("workers", 0)))
	workers = 0
	for count in staff_counts:
		workers += count
	dispatch.restore(data.get("dispatch", null))
	lifetime_deliveries = maxi(0, int(data.get("lifetime_deliveries", dispatch.completed + dispatch.founder_completed)))
	achievement_claimed.clear()
	var saved_claims = data.get("achievement_claimed", [])
	if saved_claims is Array:
		for item in Achievements.ITEMS:
			if saved_claims.has(item[0]): achievement_claimed.append(str(item[0]))
	var old_index := int(data.get("route_index", 0))
	pickup_index = posmod(int(data.get("pickup_index", old_index)), PICKUPS.size())
	drop_index = posmod(int(data.get("drop_index", old_index)), DROPS.size())
	order_payout = max(0, int(data.get("order_payout", 0)))
	if order_payout <= 0:
		order_payout = _calculate_payout(pickup_index, drop_index)
	carrying = bool(data.get("carrying", false))
	var saved_camera = data.get("camera_center", [])
	if saved_camera is Array and saved_camera.size() == 2:
		camera_center = Vector2(float(saved_camera[0]), float(saved_camera[1]))
	camera_zoom = clampf(float(data.get("camera_zoom", 2.1)), 1.0, MAX_MAP_ZOOM)
	camera_follow = bool(data.get("camera_follow", true))
	if district_index == 0 and not data.has("camera_follow"):
		camera_center = player + Vector2(0, 55)
		camera_zoom = maxf(camera_zoom, 2.1)
	last_saved_at = int(data.get("last_saved_at", 0))
	if data.has("rng_state"):
		rng.state = int(str(data["rng_state"]))
	if int(data.get("economy_version", 0)) < 1:
		_settle_legacy_offline()
		for job in dispatch.pending + dispatch.active:
			job["district"] = district_index
			job["paid"] = int(round(int(job["payout"]) * _income_multiplier()))
			job["founder_base"] = int(job["payout"]) + vehicle * 12
			job["founder_paid"] = int(round(int(job["founder_base"]) * _income_multiplier()))
		_seed_founder_job(true)
		simulation_economy_version = 1
	else:
		simulation_initialized = true
	_sync_founder_state()
	if has_started:
		var income := _apply_offline_income()
		if income > 0:
			message = "Sen yokken +%s ₺ kazanıldı!" % Numbers.compact(income)
			message_clock = 8.0
	else:
		last_saved_at = int(Time.get_unix_time_from_system())
	if simulation_economy_version < 2:
		simulation_economy_version = 2
		_maybe_unlock_team()
		migration_notice = "Yeni araç, hizmet ve ekip yatırımları hazır.\nMevcut paran, araçların ve çalışanların korundu.\nKabul edilmiş işler eski ücretleriyle tamamlanacak."
		if bool(data.get("company", false)):
			money += Economy.LEGACY_COMPANY_COST
			migration_notice += "\n\nKaldırılan şirket giriş bedeli: +9.000 ₺ kasana iade edildi. Bu tutar ciroya eklenmedi."

	if simulation_economy_version < 3:
		unlocked_district_index = maxi(unlocked_district_index, district_index)
		if not data.has("album_unlocked"):
			for index in range(DISTRICTS.size() if rebirth_count > 0 else unlocked_district_index + 1):
				_collect_district(index)
		simulation_economy_version = 3
		_update_district()
		migration_notice += "\n\nİlçeler artık otomatik değişmez; açılan ilçeyi sen seçersin. Ulaşılan ilçeler ve albüm keşifleri korundu."
	if simulation_economy_version < 4:
		simulation_economy_version = 4
		migration_notice += "\n\nİstanbul İtibarı: %d tamamlanan turun korundu.\nKalıcı kazanç +%d%% → +%d%%. Her yeni tur +25 yüzde puan verir. Kabul edilmiş işlerin ücretleri değişmez." % [rebirth_count, rebirth_count * 10, rebirth_count * 25]
	if simulation_economy_version < 5:
		simulation_economy_version = 5
		_update_district()
		migration_notice += "\n\nİlk yeni ilçe hedefi 550 ₺ olarak ayarlandı. Açılmış ilçelerin, itibarın ve paran korundu. Deneme ölçümleri yalnızca bu cihazda tutulur."
	if simulation_economy_version < 6:
		var role := vehicle
		starter_role = role
		var slot: int = staff_counts[role]
		for job in dispatch.active:
			if int(job["role"]) == Dispatch.FOUNDER:
				job["role"] = role
				job["slot"] = slot
				job["paid"] = int(job.get("founder_paid", job["paid"]))
		staff_counts[role] += 1
		workers = 0
		for count in staff_counts: workers += count
		company = true
		simulation_economy_version = 6
		migration_notice += "\n\nŞirket yönetimine geçildi. Eski kuryen filona eklendi; paran ve işler korundu. Şirket adını ve logonu seçebilirsin."
	if simulation_economy_version < 7:
		legacy_speed_floor = _company_speeds().duplicate()
		simulation_economy_version = 7
		migration_notice += "\n\nFilo uzmanlıkları güncellendi. Mevcut tur hedefin ve satın alınmış hız kazanımların korundu. Eski işler ücret/sürelerini tutar. Yeni turda yeni denge başlar."
	district_selection = district_index

func _settle_legacy_offline() -> void:
	# One-time settlement under the old rules. Never used after economy v1.
	var now := int(Time.get_unix_time_from_system())
	var absence := maxi(0, now - last_saved_at) if last_saved_at > 0 and has_started else 0
	var elapsed := mini(absence, OFFLINE_LIMIT_SECONDS)
	last_saved_at = maxi(last_saved_at, now)
	if elapsed <= 0:
		return
	var solo := _credit(int(floor(float(elapsed) / 60.0 * OFFLINE_RATE_PER_MINUTE[vehicle])))
	var team := 0
	var completed_before := dispatch.completed
	if company:
		var old = load("res://scripts/legacy_dispatch.gd").new()
		old.restore(dispatch.to_save())
		var remaining := float(elapsed)
		while remaining > 0.0:
			var step := minf(15.0, remaining)
			for job in old.advance(step, staff_counts, district_index, _make_company_order):
				team += _credit(int(job["payout"]))
			remaining -= step
		dispatch.restore(old.to_save())
	if elapsed >= 60 and solo + team > 0:
		_accumulate_return_summary(elapsed, solo, team, dispatch.completed - completed_before, absence > OFFLINE_LIMIT_SECONDS)

func _accumulate_return_summary(seconds: int, solo: int, team: int, finished: int, capped: bool, stars: int = 0) -> void:
	return_summary["stars"] = int(return_summary.get("stars", 0)) + stars
	return_summary["seconds"] = int(return_summary.get("seconds", 0)) + seconds
	return_summary["solo"] = int(return_summary.get("solo", 0)) + solo
	return_summary["team"] = int(return_summary.get("team", 0)) + team
	return_summary["completed"] = int(return_summary.get("completed", 0)) + finished
	return_summary["capped"] = int(return_summary.get("capped", 0)) + int(capped)

func _apply_offline_income() -> int:
	var now := int(Time.get_unix_time_from_system())
	if last_saved_at <= 0:
		last_saved_at = now
		return 0
	var absence := maxi(0, now - last_saved_at)
	var elapsed := mini(absence, OFFLINE_LIMIT_SECONDS)
	last_saved_at = maxi(last_saved_at, now)
	var report := _advance_simulation(float(elapsed))
	var income := int(report["solo"]) + int(report["team"])
	if elapsed >= 60 and income > 0:
		local_metrics.begin_visit()
		local_metrics.record("offline_return", {"absence_seconds": absence, "accounted_seconds": elapsed, "income": income, "solo": int(report["solo"]), "team": int(report["team"]), "capped": absence > OFFLINE_LIMIT_SECONDS})
		_accumulate_return_summary(elapsed, int(report["solo"]), int(report["team"]), int(report["completed"]), absence > OFFLINE_LIMIT_SECONDS, int(report.get("stars", 0)))
	return income

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("102536"))
	_draw_static_map()
	if district_panel != null and district_panel.visible:
		draw_rect(_map_rect(), Color("06121c", 0.55))
	if simulation_economy_version < 6: draw_style_box(mission_card_style, Rect2(12, 121, size.x - 24, 35))
	hud.draw()

func _static_map_texture() -> Texture2D:
	match district_index:
		0: return STATIC_MAP_SILE
		1: return STATIC_MAP_BEYKOZ
		2: return STATIC_MAP_USKUDAR
		3: return STATIC_MAP_KADIKOY
		4: return STATIC_MAP_BESIKTAS
		5: return STATIC_MAP_SISLI
		6: return STATIC_MAP_BEYOGLU
	return STATIC_MAP_CITY

func _map_location_positions() -> Array:
	match district_index:
		0: return LOCATION_POSITIONS
		1: return BEYKOZ_LOCATION_POSITIONS
		2: return USKUDAR_LOCATION_POSITIONS
		3: return KADIKOY_LOCATION_POSITIONS
		4: return BESIKTAS_LOCATION_POSITIONS
		5: return SISLI_LOCATION_POSITIONS
		6: return BEYOGLU_LOCATION_POSITIONS
	return CITY_LOCATION_POSITIONS

func _static_map_source() -> Rect2:
	return map_view.source_rect()

func _draw_static_map() -> void:
	map_view.draw()

func _build_return_summary() -> void:
	return_overlay = ColorRect.new()
	return_overlay.color = Color("06121cd9")
	return_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	return_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(return_overlay)
	return_panel = FRAMED_PANEL.instantiate()
	return_panel.size = Vector2(440, 588)
	return_overlay.add_child(return_panel)
	_label(Vector2(24, 18), Vector2(350, 32), 24, Color("f9b553"), return_panel).text = "TEKRAR HOŞ GELDİN"
	return_time_label = _label(Vector2(24, 57), Vector2(392, 40), 13, Color("a6b9c5"), return_panel)
	return_total_label = _label(Vector2(24, 105), Vector2(392, 48), 36, Color("70dfcf"), return_panel)
	_label(Vector2(24, 154), Vector2(392, 22), 13, Color("fff0d1"), return_panel).text = "Kazanç kasana eklendi • Teslimatlar sürüyor"
	return_breakdown_label = _label(Vector2(24, 189), Vector2(392, 58), 12, Color("fff0d1"), return_panel)
	return_goal_label = _label(Vector2(24, 252), Vector2(392, 60), 12, Color("ffcf71"), return_panel)
	return_goal_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	for i in 3:
		var choice := _button(Vector2(24, 318 + i * 66), Vector2(392, 60), _open_return_choice.bind(i), return_panel)
		choice.add_theme_font_size_override("font_size", 12)
		return_choice_buttons.append(choice)
	var close := _button(Vector2(24, 528), Vector2(392, 44), _dismiss_return_summary, return_panel)
	close.text = "OYUNA DÖN"
	_primary_button(close)
	return_overlay.visible = false

func _show_return_summary() -> void:
	if return_overlay == null or menu_overlay.visible or settings_overlay.visible or int(return_summary.get("solo", 0)) + int(return_summary.get("team", 0)) <= 0:
		return
	if company_ui != null: company_ui.close_all()
	_close_location_card()
	_refresh_ui()
	var seconds := int(return_summary.get("seconds", 0))
	return_time_label.text = "Hesaplanan süre: %d sa %d dk" % [seconds / 3600, (seconds % 3600) / 60]
	if int(return_summary.get("capped", 0)) > 0:
		return_time_label.text += "\nHer ayrılışta en fazla 4 saat kazanç hesaplanır."
	return_total_label.text = "+%s ₺" % Numbers.compact(int(return_summary.get("solo", 0)) + int(return_summary.get("team", 0)))
	return_breakdown_label.text = "Kuryen: +%s ₺\nEkibin: +%s ₺ • %s teslimat" % [Numbers.compact(int(return_summary.get("solo", 0))), Numbers.compact(int(return_summary.get("team", 0))), Numbers.compact(int(return_summary.get("completed", 0)))]
	if simulation_economy_version >= 6:
		return_breakdown_label.text = "Filo: +%s ₺\nTamamlanan ekip teslimatı: %s" % [Numbers.compact(int(return_summary.get("solo", 0)) + int(return_summary.get("team", 0))), Numbers.compact(int(return_summary.get("completed", 0)))]
	return_breakdown_label.text += "\nYıldız: +%d • Sonraki: %d/100 teslimat" % [int(return_summary.get("stars", 0)), star_progress]
	guide_panel.hide()
	district_panel.hide()
	return_overlay.visible = true
	_refresh_return_choices()


func _dismiss_return_summary() -> void:
	return_overlay.visible = false
	return_summary.clear()
	_save_game()


func _market_profile(region: int = -1) -> Dictionary:
	if region < 0: region = district_index
	if market_cache.has(region): return market_cache[region]
	var network := RoadNetwork.new()
	if region == 0:
		for point in sile_map["nodes"]: network.add_node(Vector2(float(point[0]), float(point[1])))
		for edge in sile_map["edges"]: network.connect_nodes(int(edge[0]), int(edge[1]))
	else:
		for y in ROAD_Y:
			for x in ROAD_X: network.add_node(Vector2(x, y))
		for row in ROAD_Y.size():
			for column in ROAD_X.size():
				var node: int = row * ROAD_X.size() + column
				if row + 1 < ROAD_Y.size(): network.connect_nodes(node, node + ROAD_X.size())
				if column == 0 or column == 2 or (row == 2 and column == 1): network.connect_nodes(node, node + 1)
	var distances: Array[float] = []
	var sum := 0.0
	for pickup in PICKUPS.size():
		for drop in DROPS.size():
			var start: Vector2 = network.nodes[int(sile_map["pickup_nodes"][pickup])] if region == 0 else PICKUPS[pickup]["position"]
			var finish: Vector2 = network.nodes[int(sile_map["drop_nodes"][drop])] if region == 0 else DROPS[drop]["position"]
			if start == finish: continue
			var distance := _network_distance(network, start, finish)
			distances.append(distance)
			sum += distance
	var mean := maxf(1.0, sum / maxf(1.0, distances.size()))
	var base_fares: Array[int] = []
	for distance in distances: base_fares.append(int(round(12.0 + 8.0 * distance / mean)))
	var result := {"mean_distance": mean, "base_fares": base_fares}
	market_cache[region] = result
	return result

func _production_snapshot(next_vehicle: int = -1, next_service: int = -1, extra_role: int = -1, region: int = -1, upgrades: Dictionary = {}) -> Dictionary:
	if region < 0: region = district_index
	var chosen_vehicle := vehicle if next_vehicle < 0 else next_vehicle
	if simulation_economy_version >= 6: chosen_vehicle = 0
	var chosen_service := service_level if next_service < 0 else next_service
	var distance: float = Economy.DISTRICT_DISTANCE[region] if simulation_economy_version >= 3 else Economy.REFERENCE_DISTANCE
	var founder_seconds := dispatch.delivery_seconds(chosen_vehicle, region, distance)
	var chosen_bonus: int = int(upgrades.get("bonus", bonus_level))
	var chosen_operations: int = int(upgrades.get("operations", operations_level))
	var chosen_comfort: int = int(upgrades.get("comfort", comfort_level))
	var preview_speeds: Array = Specialization.apply(Economy.company_speeds(region, chosen_comfort, chosen_operations, simulation_economy_version, legacy_speed_floor), specialization_id)
	founder_seconds = distance * (1.0 + region * 0.08) / float(preview_speeds[chosen_vehicle])
	var capacity := 0.0 if simulation_economy_version >= 6 else 60.0 / founder_seconds
	for role in staff_counts.size():
		var count: int = staff_counts[role] if company else 0
		if role == extra_role: count += 1
		capacity += count * 60.0 / (distance * (1.0 + region * 0.08) / float(preview_speeds[role]))
	var fares: Array = _market_profile(region)["base_fares"]
	var mean_pay := 0.0
	for base in fares:
		mean_pay += int(round(float(base) * Economy.service_multiplier(chosen_service) * (1.0 + region * 0.25) * _motivation_multiplier() * Economy.reputation_multiplier(rebirth_count, simulation_economy_version) * (1.0 + chosen_bonus * 0.05 if simulation_economy_version >= 6 else 1.0)))
	mean_pay /= maxf(1.0, fares.size())
	var demand := float(Economy.DEMAND_PER_MINUTE[region])
	var bottleneck := "Taşıma sınırlı" if capacity < demand - 0.001 else "Talep sınırlı"
	if region == district_index and capacity >= demand and not dispatch.pending.is_empty(): bottleneck = "Kuyruk eriyor"
	return {"capacity": capacity, "demand": demand, "mean_pay": mean_pay, "income": minf(capacity, demand) * mean_pay, "founder_seconds": founder_seconds, "bottleneck": bottleneck}


func _investment(kind: String, role: int = -1) -> Dictionary:
	var before := _production_snapshot()
	var after := before
	var cost := 0
	if kind == "vehicle" and vehicle < 3:
		after = _production_snapshot(vehicle + 1)
		cost = COSTS[vehicle + 1]
	elif kind == "service" and service_level < Economy.MAX_SERVICE_LEVEL:
		after = _production_snapshot(-1, service_level + 1)
		cost = Economy.service_cost(service_level)
	elif kind == "worker":
		after = _production_snapshot(-1, -1, role)
		cost = _staff_cost(role)
	elif kind in ["bonus", "comfort", "operations"]:
		var level: int = bonus_level if kind == "bonus" else (comfort_level if kind == "comfort" else operations_level)
		if level < 20:
			after = _production_snapshot(-1, -1, -1, -1, {kind: level + 1})
			cost = Economy.team_bonus_cost(level) if kind == "bonus" else (Economy.comfort_cost(level) if kind == "comfort" else Economy.operations_cost(level))
	var gain := maxf(0.0, float(after["income"]) - float(before["income"]))
	return {"cost": cost, "gain": gain, "before": before, "after": after, "requirement": _upgrade_requirement(kind), "payback": cost / gain if gain > 0.001 else -1.0}

func _investment_tooltip(investment: Dictionary) -> String:
	var text := "Bedel: %s ₺\n" % Numbers.exact(int(investment["cost"]))
	text += "Kuyruk dengelendiğinde beklenen katkı: ~+%s ₺/dk.\nGerçek sonuç sipariş mesafelerine göre değişir." % _rate(float(investment["gain"]))
	if float(investment["gain"]) <= 0.001:
		text += "\nTalep sınırlı: bu alım şu anda sürekli geliri artırmaz."
		if not dispatch.pending.is_empty():
			text += " Birikmiş kuyruğun erimesine yardımcı olabilir."
	else:
		text += "\nYaklaşık geri ödeme: %s dk (aynı ilçe ve koşullarda)." % _rate(float(investment["payback"]))
	return text

func _purchase_target(cost: int) -> String:
	return "%s ₺ kaldı" % Numbers.compact(maxi(0, cost - money)) if money < cost else "Satın almaya hazır"

func _rate(value: float) -> String:
	return Numbers.compact(value, 1)

func _build_migration_dialog() -> void:
	migration_dialog = AcceptDialog.new()
	migration_dialog.title = "İşletme güncellendi"
	migration_dialog.theme = UI_THEME
	migration_dialog.borderless = true
	migration_dialog.add_theme_stylebox_override("panel", _button_style(Color("071d2c"), Color("f9b553")))
	migration_dialog.add_theme_constant_override("buttons_min_height", 42)
	migration_dialog.get_label().add_theme_font_size_override("font_size", 14)
	migration_dialog.get_label().add_theme_color_override("font_color", Color("fff0d1"))
	_primary_button(migration_dialog.get_ok_button())
	migration_dialog.get_label().autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	migration_dialog.min_size = Vector2i(400, 220)
	migration_dialog.ok_button_text = "ANLADIM"
	migration_dialog.confirmed.connect(_dismiss_migration_notice)
	migration_dialog.canceled.connect(_dismiss_migration_notice)
	add_child(migration_dialog)

func _show_migration_notice() -> void:
	if not migration_notice.is_empty():
		migration_dialog.dialog_text = migration_notice
		migration_dialog.popup_centered(Vector2i(400, 220))

func _dismiss_migration_notice() -> void:
	migration_dialog.hide()
	migration_notice = ""
	_save_game()

# Optional, state-based lessons: no timed modal, forced purchase or lost reward.
func _return_investments() -> Array[Dictionary]:
	var options: Array[Dictionary] = []
	for kind in ["vehicle", "service", "worker"]:
		if kind == "vehicle" and vehicle >= 3: continue
		if kind == "service" and service_level >= Economy.MAX_SERVICE_LEVEL: continue
		if kind == "worker" and not company: continue
		var role := 0
		if kind == "worker":
			# Best positive marginal return per cost; no idle capacity recommendation.
			var best := -1.0
			for i in STAFF_NAMES.size():
				var candidate := _investment("worker", i)
				var efficiency := float(candidate["gain"]) / maxi(1, int(candidate["cost"]))
				if efficiency > best:
					best = efficiency
					role = i
		var investment := _investment(kind, role)
		if float(investment["gain"]) <= 0.001: continue
		investment["kind"] = kind
		investment["role"] = role
		investment["name"] = VEHICLES[vehicle + 1] if kind == "vehicle" else "Hizmet %d" % (service_level + 1) if kind == "service" else "%s kurye" % STAFF_NAMES[role]
		options.append(investment)
	options.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var affordable_a := money >= int(a["cost"])
		var affordable_b := money >= int(b["cost"])
		if affordable_a != affordable_b: return affordable_a
		return float(a["payback"]) < float(b["payback"]))
	return options

func _refresh_return_choices() -> void:
	var snapshot := _production_snapshot()
	var target := "Yeni tur: %s / %s ₺ tur cirosu" % [Numbers.compact(run_earned), Numbers.compact(run_prestige_target)]
	if unlocked_district_index + 1 < DISTRICTS.size():
		target = "%s: %s / %s ₺ tur cirosu" % [DISTRICTS[unlocked_district_index + 1], Numbers.compact(run_earned), Numbers.compact(DISTRICT_THRESHOLDS[unlocked_district_index + 1])]
	return_goal_label.text = "ŞİMDİ: %s • Kasa %s ₺\nTalep %s / kapasite %s iş/dk\nHEDEF: %s" % [snapshot["bottleneck"], Numbers.compact(money), _rate(float(snapshot["demand"])), _rate(float(snapshot["capacity"])), target]
	if unlocked_district_index > district_index:
		target = "%s açık • İlçe ekranından seç" % DISTRICTS[unlocked_district_index]
		return_goal_label.text = "ŞİMDİ: %s • Kasa %s ₺\nTalep %s / kapasite %s iş/dk\nHEDEF: %s" % [snapshot["bottleneck"], Numbers.compact(money), _rate(float(snapshot["demand"])), _rate(float(snapshot["capacity"])), target]
	return_choices = _return_investments()
	if motivation_level < 20 and motivation_stars >= _motivation_cost():
		return_choices.push_front({"kind": "motivation", "name": "Kalıcı motivasyon: %d yıldız" % _motivation_cost()})
	elif Achievements.available(self) > 0:
		return_choices.push_front({"kind": "achievements", "name": "Hazır başarım ödülleri: %d" % Achievements.available(self)})
	if unlocked_district_index > district_index:
		return_choices.push_front({"kind": "district", "name": "Açık ilçeleri karşılaştır"})
		if return_choices.size() > 3: return_choices.resize(3)
	if return_choices.size() < 3 and not return_choices.any(func(row: Dictionary) -> bool: return row["kind"] == "district"):
		return_choices.append({"kind": "district", "name": "İlçe hedefini incele"})
	if return_choices.size() < 3:
		return_choices.append({"kind": "guide", "name": "Yatırım rehberini aç"})
	for i in return_choice_buttons.size():
		var button := return_choice_buttons[i]
		button.visible = i < return_choices.size()
		if not button.visible: continue
		var choice := return_choices[i]
		if choice.has("cost"):
			button.text = "%s • %s ₺ • ~+%s ₺/dk\n%s • İncele ›" % [choice["name"], Numbers.compact(int(choice["cost"])), _rate(float(choice["gain"])), _purchase_target(int(choice["cost"]))]
			button.tooltip_text = _investment_tooltip(choice) + "\nBu düğme satın almaz; yatırım ekranına döner."
		else:
			button.text = "%s ›\n%s" % [choice["name"], "Yeni iş kapasitesini karşılaştır" if choice["kind"] == "district" else ("Kalıcı yüzde bonusunu incele" if choice["kind"] == "motivation" else ("Yıldız ödüllerini incele" if choice["kind"] == "achievements" else "Hız, ücret ve kapasite farkı"))]
			button.tooltip_text = "Bilgi ekranını aç; satın alma yapılmaz."

func _open_return_choice(index: int) -> void:
	if not return_overlay.visible: return
	# Re-evaluate after ongoing deliveries; the displayed row is informational.
	if index < 0 or index >= return_choices.size(): return
	var choice: Dictionary = return_choices[index].duplicate()
	_dismiss_return_summary()
	match str(choice["kind"]):
		"motivation": company_ui.open_tab(1)
		"achievements": company_ui.open_tab(5)
		"worker":
			if company: _toggle_company_panel()
		"district": _toggle_district_panel()
		"guide": _toggle_guide()
		"vehicle", "service":
			if simulation_economy_version >= 6:
				company_ui.open_tab(0)
				return
			_announce("%s: alt yatırım kartından inceleyip seçebilirsin" % choice["name"])

const DISTRICT_CARD_NAMES := ["Şile • Deniz Feneri", "Beykoz • Anadolu Hisarı", "Üsküdar • Kız Kulesi", "Kadıköy • Haydarpaşa", "Beşiktaş • Dolmabahçe", "Şişli • Atatürk Müzesi", "Beyoğlu • Galata Kulesi"]
const DISTRICT_IDENTITIES := ["Sakin kıyı başlangıcı", "Uzun kıyı teslimatları", "İskele çevresinde sık iş", "Yoğun esnaf siparişleri", "Yoğunluk ve yüksek ücret", "Uzun servis, yüksek hacim", "Yokuşlar ve sıkışık yollar"]

func _district_texture(index: int) -> Texture2D:
	return [STATIC_MAP_SILE, STATIC_MAP_BEYKOZ, STATIC_MAP_USKUDAR, STATIC_MAP_KADIKOY, STATIC_MAP_BESIKTAS, STATIC_MAP_SISLI, STATIC_MAP_BEYOGLU][index]

func _select_district(index: int) -> void:
	district_selection = clampi(index, 0, DISTRICTS.size() - 1)
	_refresh_district_panel()

func _activate_selected_district() -> void:
	_activate_district(district_selection)

func _refresh_district_panel() -> void:
	var selected := district_selection
	var current := _production_snapshot()
	var preview := _production_snapshot(-1, -1, -1, selected)
	for i in district_select_buttons.size():
		var suffix := " •" if i == district_index else " +" if i <= unlocked_district_index else " ×"
		district_select_buttons[i].text = DISTRICTS[i] + suffix
		district_select_buttons[i].modulate = Color("ffcf71") if i == selected else Color.WHITE
	district_name_label.text = "%s • %s" % [DISTRICTS[selected], "ETKİN" if selected == district_index else "AÇIK" if selected <= unlocked_district_index else "KİLİTLİ"]
	district_postcard.texture = _district_texture(selected)
	district_comparison.text = "Mevcut → Seçili (tahmini)\nTalep %s → %s iş/dk\nYaya ~%s → %s sn\nÜcret ~%s → %s ₺/iş\nGelir ~%s → %s ₺/dk" % [_rate(float(current["demand"])), _rate(float(preview["demand"])), _rate(float(current["founder_seconds"])), _rate(float(preview["founder_seconds"])), _rate(float(current["mean_pay"])), _rate(float(preview["mean_pay"])), _rate(float(current["income"])), _rate(float(preview["income"]))]
	var next_goal := "Yeni tur: %s / %s ₺" % [Numbers.compact(run_earned), Numbers.compact(run_prestige_target)]
	var threshold := run_prestige_target
	if unlocked_district_index + 1 < DISTRICTS.size():
		threshold = DISTRICT_THRESHOLDS[unlocked_district_index + 1]
		next_goal = "%s açılışı: %s / %s ₺" % [DISTRICTS[unlocked_district_index + 1], Numbers.compact(run_earned), Numbers.compact(threshold)]
	district_progress_label.text = "%s • %s\n%s tur cirosu" % [DISTRICT_IDENTITIES[selected], preview["bottleneck"], next_goal]
	district_progress_bar.max_value = threshold
	district_progress_bar.value = run_earned
	district_activate_button.disabled = selected > unlocked_district_index or selected == district_index
	district_activate_button.text = "BURADA ÇALIŞIYORSUN" if selected == district_index else "AÇILIŞ İÇİN %s ₺ TUR CİROSU" % Numbers.compact(DISTRICT_THRESHOLDS[selected]) if selected > unlocked_district_index else "%s İLÇESİNDE ÇALIŞ" % DISTRICTS[selected].to_upper()
	district_activate_button.tooltip_text = "Eski işler ücret ve sürelerini korur. Yeni siparişler seçili ilçeden gelir. Tahmin birikmiş kuyruğu içermez."
	album_button.text = "İSTANBUL ALBÜMÜ • %d / 7 KARTPOSTAL ›" % album_unlocked.size()
	for i in album_images.size():
		var collected := album_unlocked.has(i)
		album_images[i].modulate = Color.WHITE if collected else Color("263747")
		album_labels[i].text = DISTRICT_CARD_NAMES[i] if collected else "%s • Henüz ziyaret edilmedi" % DISTRICTS[i]

func _build_album() -> void:
	album_panel = FRAMED_PANEL.instantiate()
	album_panel.position = Vector2(16, 54)
	album_panel.size = Vector2(416, 536)
	album_panel.add_theme_stylebox_override("panel", _button_style(Color("071d2c"), Color("f9b553")))
	district_panel.add_child(album_panel)
	_label(Vector2(10, 7), Vector2(396, 28), 18, Color("ffcf71"), album_panel).text = "İSTANBUL ALBÜMÜ • KALICI KEŞİFLER"
	album_scroll = ScrollContainer.new()
	album_scroll.position = Vector2(10, 43)
	album_scroll.size = Vector2(396, 394)
	album_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	album_panel.add_child(album_scroll)
	var content := Control.new()
	content.mouse_filter = Control.MOUSE_FILTER_PASS
	content.custom_minimum_size = Vector2(384, 726)
	album_scroll.add_child(content)
	for i in DISTRICTS.size():
		var image := TextureRect.new()
		image.position = Vector2((i % 2) * 194, (i / 2) * 182)
		image.size = Vector2(186, 140)
		image.texture = _district_texture(i)
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		content.add_child(image)
		album_images.append(image)
		var caption := _label(image.position + Vector2(0, 143), Vector2(186, 33), 12, Color("fff0d1"), content)
		caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		album_labels.append(caption)
	_label(Vector2(10, 445), Vector2(396, 35), 12, Color("70dfcf"), album_panel).text = "Tüm kartlar için kaydır • İlk çalışmada kazanılır.\nTekrar çıkmaz; yeni turda korunur."
	var close := _button(Vector2(10, 486), Vector2(396, 36), _toggle_album, album_panel)
	close.text = "İLÇELERE DÖN"
	album_panel.hide()

func _toggle_album() -> void:
	album_panel.visible = not album_panel.visible
	_refresh_district_panel()

func _track_investment(kind: String, cost: int, level: int) -> void:
	var snapshot := _production_snapshot()
	local_metrics.record("investment", {"kind": kind, "cost": cost, "level_or_role": level, "cash_after": money, "district": district_index, "bottleneck_after": snapshot["bottleneck"], "income_estimate_after": snapshot["income"]})
	if is_instance_valid(feedback):
		var label: String = STAFF_NAMES[level] + " kurye işe başladı" if kind == "worker" else str({"service":"Hizmet kalitesi", "bonus":"Teslimat primi", "comfort":"Çalışma konforu", "operations":"Operasyon merkezi", "vehicle":"Araç"}.get(kind,"Şirket")) + " geliştirildi"
		feedback.purchase(label)

func _handle_android_back() -> void:
	if model_menu.visible:
		model_menu.hide()
		return
	if company_ui != null and company_ui.blocks_map():
		company_ui.close_all()
		return
	if rebirth_dialog.visible:
		rebirth_dialog.hide()
	elif reset_dialog.visible:
		reset_dialog.hide()
	elif migration_dialog.visible:
		_dismiss_migration_notice()
	elif return_overlay.visible:
		_dismiss_return_summary()
	elif settings_overlay.visible:
		_close_settings()
	elif guide_panel.visible:
		_toggle_guide()
	elif district_panel.visible:
		if album_panel.visible: _toggle_album()
		else: _toggle_district_panel()
	elif selected_location >= 0:
		_close_location_card()
	elif not menu_overlay.visible:
		_save_game()
		_back_to_menu()
	else:
		_save_game()
		get_tree().quit()

func _focus_job() -> Dictionary:
	if simulation_economy_version < 6: return dispatch.founder_job()
	return dispatch.active[0] if not dispatch.active.is_empty() else {}

func _claim_achievement(id: String) -> void:
	if achievement_claimed.has(id) or not save_store.writable: return
	for item in Achievements.ITEMS:
		if str(item[0]) != id or Achievements.progress(self, item) < int(item[3]): continue
		var candidate := _save_data().duplicate(true)
		candidate["last_saved_at"] = maxi(last_saved_at, int(Time.get_unix_time_from_system()))
		candidate["achievement_claimed"].append(id)
		candidate["motivation_stars"] = motivation_stars + int(item[4])
		if not save_store.write_record(SAVE_PATH, candidate):
			_announce("Başarım kaydedilemedi; ödülün korunuyor")
			return
		last_saved_at = int(candidate["last_saved_at"])
		achievement_claimed.append(id)
		motivation_stars = int(candidate["motivation_stars"])
		_refresh_ui()
		if is_instance_valid(feedback): feedback.milestone("Başarım • %s • +%d yıldız" % [item[1], item[4]])
		return

func _motivation_multiplier() -> float:
	return 1.0 + motivation_level * 0.20

func _motivation_cost() -> int:
	return int(ceil(10.0 * pow(1.45, motivation_level)))

func _buy_motivation() -> void:
	if motivation_level >= 20 or motivation_stars < _motivation_cost() or not save_store.writable: return
	var candidate := _save_data().duplicate(true)
	candidate["last_saved_at"] = maxi(last_saved_at, int(Time.get_unix_time_from_system()))
	candidate["motivation_stars"] = motivation_stars - _motivation_cost()
	candidate["motivation_level"] = motivation_level + 1
	if not save_store.write_record(SAVE_PATH, candidate):
		_announce("Motivasyon kaydedilemedi; yıldızların korundu")
		return
	last_saved_at = int(candidate["last_saved_at"])
	motivation_stars = int(candidate["motivation_stars"])
	motivation_level += 1
	_refresh_ui()
	if is_instance_valid(feedback): feedback.milestone("Kalıcı motivasyon +%d%%" % (motivation_level * 20))

func _company_speeds() -> Array:
	return Specialization.apply(Economy.company_speeds(district_index, comfort_level, operations_level, simulation_economy_version, legacy_speed_floor), specialization_id)

func _role_seconds(role: int) -> float:
	return Economy.DISTRICT_DISTANCE[district_index] * (1.0 + district_index * 0.08) / float(_company_speeds()[role])

func _upgrade_requirement(kind: String) -> String:
	if simulation_economy_version < 7: return ""
	if kind == "bonus" and bonus_level == 0 and workers < 3: return "3 çalışanla açılır."
	if kind == "operations" and operations_level == 0 and staff_counts[2] + staff_counts[3] == 0: return "İlk motor veya araba ile açılır."
	return ""

func _seed_company_job() -> void:
	if workers <= 0 or not dispatch.active.is_empty() or not dispatch.pending.is_empty(): return
	dispatch.pending.append(_order_quote(0, 0))
	dispatch.advance(0.0, staff_counts, district_index, _make_company_order, -1)

func _create_company(name_text: String, logo: int) -> bool:
	var cleaned := name_text.strip_edges().left(24)
	if cleaned.length() < 2: return false
	if menu_overlay.visible and has_started: _apply_offline_income()
	company_name = cleaned
	company_logo = clampi(logo, 0, 8)
	brand_ready = true
	company = true
	if workers <= 0:
		staff_counts.assign([1, 0, 0, 0])
		workers = 1
	_seed_company_job()
	_save_game()
	company_ui.close_all()
	if menu_overlay.visible: _start_playing()
	else: _refresh_ui()
	return true

func _buy_company_upgrade(kind: String) -> void:
	if not _upgrade_requirement(kind).is_empty(): return
	var level := bonus_level if kind == "bonus" else comfort_level if kind == "comfort" else operations_level
	if level >= 20: return
	var cost := Economy.team_bonus_cost(level) if kind == "bonus" else Economy.comfort_cost(level) if kind == "comfort" else Economy.operations_cost(level)
	if money < cost: return
	money -= cost
	if kind == "bonus": bonus_level += 1
	elif kind == "comfort": comfort_level += 1
	else: operations_level += 1
	_track_investment(kind, cost, level + 1)
	_save_game()
	_refresh_ui()

func _build_guide() -> void:
	guide_panel = FRAMED_PANEL.instantiate()
	guide_panel.position = Vector2(16, 163)
	guide_panel.size = Vector2(448, 238)
	add_child(guide_panel)
	guide_title = _label(Vector2(16, 12), Vector2(414, 28), 19, Color("ffcf71"), guide_panel)
	guide_body = _label(Vector2(16, 46), Vector2(414, 94), 15, Color("fff0d1"), guide_panel)
	guide_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	guide_goal = _label(Vector2(16, 143), Vector2(414, 32), 12, Color("70dfcf"), guide_panel)
	guide_goal.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var close := _button(Vector2(16, 181), Vector2(414, 44), _toggle_guide, guide_panel)
	close.text = "ANLADIM • OYUNA DÖN"
	close.add_theme_font_size_override("font_size", 13)
	guide_panel.hide()


func _toggle_guide() -> void:
	guide_panel.visible = not guide_panel.visible
	if guide_panel.visible:
		_close_location_card()
		district_panel.hide()
		guide_seen = true
		_save_game()
	_refresh_guide()


func _refresh_guide() -> void:
	if simulation_economy_version >= 6:
		guide_title.text = "ŞİRKET YÖNETİMİ"
		guide_body.text = "Filo: kurye ekle. Geliştir: hizmet, prim ve konfor. Motivasyon: yıldızla kalıcı kazanç. Şirket: operasyon, ilçeler ve başarımlar. Teslimatlar otomatik ilerler."
		guide_goal.text = "Talep ve kapasiteyi karşılaştır; gösterilen ₺/sn tahmini ortalamadır."
		return

