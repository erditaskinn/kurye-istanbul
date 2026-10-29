extends "res://tools/capture_company.gd"
func capture() -> void:
	AudioServer.set_bus_mute(0,true) # Preview process only; never alters system volume.
	root.size=Vector2i(480,800)
	var game=load("res://scenes/Main.tscn").instantiate();root.add_child(game);game.set_process(false);game.feedback.set_process(false)
	game._reset_progress();game.rng.seed=4242;game._create_company("Martı Kurye",0)
	game.money=10000;game._process(60);game.feedback._process(.1)
	await screen("r5-delivery")
	game._hire_worker(0);await screen("r5-purchase")
	game.run_earned=game.DISTRICT_THRESHOLDS[1]-1;game._process(90);game.feedback._process(.1)
	await screen("r5-district")
	game._open_settings();game.feedback._process(.1);await screen("r5-settings-off")
	game._toggle_sound();game._toggle_haptics();await screen("r5-settings-on")
	root.size=Vector2i(480,1040);await screen("r5-settings-tall")
	print("R5 real-event delivery/purchase/unlock and settings previews captured; sound muted only in capture process")
	quit()
