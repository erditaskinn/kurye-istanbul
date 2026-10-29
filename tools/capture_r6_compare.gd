extends "res://tools/capture_company.gd"
const Previous = preload("res://build/r6/baseline/Main.tscn")
const Current = preload("res://scenes/Main.tscn")
var hashes: Dictionary={}
var failures: Array[String]=[]
func capture() -> void:
	AudioServer.set_bus_mute(0,true)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build/r6/screens"))
	for height in [800,1040]:
		root.size=Vector2i(480,height)
		for version in ["before","after"]:
			var g=(Previous if version=="before" else Current).instantiate();root.add_child(g);g.set_process(false);g.feedback.set_process(false)
			g._reset_progress();g.rng.seed=4242;g._create_company("Martı Kurye",0);g.money=10000;g._refresh_ui()
			await capture_hash(g,version,"map",height)
			g.company_ui.open_tab(2);await capture_hash(g,version,"company",height);g.company_ui.close_all()
			g._open_settings();await capture_hash(g,version,"settings",height);g._close_settings();g.return_overlay.hide()
			g._toggle_guide();await capture_hash(g,version,"guide",height);g._toggle_guide()
			g.return_summary={"seconds":60,"team":100,"completed":5,"solo":0,"capped":0};g._show_return_summary()
			await capture_hash(g,version,"return",height)
			g.free();await process_frame
	for key in hashes:
		if hashes[key]["before"]!=hashes[key]["after"]:
			failures.append(key);push_error("R6 pixel difference: "+key)
	var file:=FileAccess.open("res://build/r6/pixel-results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"rgba_sha256":hashes,"failures":failures},"  "));file.close()
	print("R6 two-ratio pixel comparison failures=",failures.size())
	quit(0 if failures.is_empty() else 1)
func capture_hash(_g,version: String,view: String,height: int) -> void:
	await process_frame;await process_frame;await RenderingServer.frame_post_draw
	var img:=root.get_texture().get_image()
	var key:=view+"-"+str(height)
	img.save_png("res://build/r6/screens/"+version+"-"+key+".png")
	var hash:=HashingContext.new();hash.start(HashingContext.HASH_SHA256);hash.update(img.get_data())
	if not hashes.has(key):hashes[key]={}
	hashes[key][version]=hash.finish().hex_encode()
