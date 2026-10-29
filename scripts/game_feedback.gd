extends Control
# Cosmetic only: one reusable banner/player, no simulation or RNG access.
const DELIVERY_SOUND = preload("res://assets/audio/delivery.wav")
const PURCHASE_SOUND = preload("res://assets/audio/purchase.wav")
const UNLOCK_SOUND = preload("res://assets/audio/unlock.wav")
var game: Control
var frame: Panel
var text_label: Label
var icon: TextureRect
var player: AudioStreamPlayer
var pending_cash := 0
var pending_deliveries := 0
var delivery_cooldown := 0.0
var sound_cooldown := 0.0
var haptic_cooldown := 0.0
var priority_clock := 0.0
var age := 0.0
var last_kind := ""
var purchase_batch := 0
var displays := 0
var sound_plays := 0
var haptic_calls := 0
func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	frame=game.FRAMED_PANEL.instantiate()
	frame.size=Vector2(392,56)
	frame.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(frame)
	icon=TextureRect.new()
	icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	icon.position=Vector2(12,14);icon.size=Vector2(28,28)
	icon.mouse_filter=Control.MOUSE_FILTER_IGNORE
	frame.add_child(icon)
	text_label=game._label(Vector2(52,7),Vector2(328,42),15,Color("70dfcf"),frame)
	text_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	text_label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	player=AudioStreamPlayer.new()
	player.volume_db=-16
	player.max_polyphony=1
	add_child(player)
	frame.hide()
	game.resized.connect(layout)
	layout()
func layout() -> void:
	if frame==null:return
	frame.position=Vector2(roundf((game.size.x-frame.size.x)/2),game.MAP_TOP+12)
func allowed() -> bool:
	return game.has_started and not game.application_suspended and not game.menu_overlay.visible and not game.settings_overlay.visible and not game.return_overlay.visible and not game.company_ui.creation.visible and not game.reset_dialog.visible and not game.rebirth_dialog.visible and not game.migration_dialog.visible and not game.district_panel.visible and not game.album_panel.visible
func clear(stop_audio: bool = true) -> void:
	pending_cash=0;pending_deliveries=0;purchase_batch=0
	delivery_cooldown=0;priority_clock=0;age=0;last_kind=""
	if frame!=null:frame.hide()
	if player!=null and stop_audio:player.stop()
func _process(delta: float) -> void:
	sound_cooldown=maxf(0,sound_cooldown-delta)
	haptic_cooldown=maxf(0,haptic_cooldown-delta)
	if not allowed():
		clear(not game.settings_overlay.visible or game.application_suspended);return
	delivery_cooldown=maxf(0,delivery_cooldown-delta)
	priority_clock=maxf(0,priority_clock-delta)
	if frame.visible:
		age+=delta
		frame.position=Vector2(roundf((game.size.x-frame.size.x)/2),game.MAP_TOP+12-roundf(minf(6,age*4)))
		frame.modulate.a=clampf((1.8-age)/0.4,0,1)
		if age>=1.8:frame.hide()
	if pending_deliveries>0 and delivery_cooldown<=0 and priority_clock<=0:
		var amount:=pending_cash
		var count:=pending_deliveries
		pending_cash=0;pending_deliveries=0
		delivery_cooldown=5.0
		show_event("delivery","%s teslimat • +%s ₺" % [game.Numbers.compact(count),game.Numbers.compact(amount)])
func deliveries(cash: int, count: int) -> void:
	if not allowed() or count<=0 or cash<=0:return
	pending_cash+=cash;pending_deliveries+=count
func purchase(label: String) -> void:
	if not allowed():return
	purchase_batch=purchase_batch+1 if priority_clock>0 and last_kind=="purchase" else 1
	priority_clock=1.8
	show_event("purchase",label if purchase_batch==1 else "%d yatırım tamamlandı" % purchase_batch)
func milestone(label: String) -> void:
	if not allowed():return
	priority_clock=1.8
	show_event("unlock",label)
func show_event(kind: String, label: String) -> void:
	last_kind=kind;age=0;displays+=1
	layout();frame.modulate=Color.WHITE
	text_label.text=label
	text_label.add_theme_color_override("font_color",Color("70dfcf") if kind=="delivery" else Color("ffcf71"))
	icon.texture=game.UI_ICONS["package" if kind=="delivery" else ("route" if kind=="unlock" else "money")]
	frame.show()
	play_sound(kind)
	if kind!="delivery":haptic()
func play_sound(kind: String) -> void:
	if not game.sound_enabled or game.application_suspended or sound_cooldown>0:return
	player.stream=DELIVERY_SOUND if kind=="delivery" else (UNLOCK_SOUND if kind=="unlock" else PURCHASE_SOUND)
	player.play();sound_plays+=1;sound_cooldown=0.25
func haptic() -> void:
	if not game.haptics_enabled or game.application_suspended or haptic_cooldown>0:return
	if OS.has_feature("android"):
		Input.vibrate_handheld(18)
		haptic_calls+=1
	haptic_cooldown=0.35
