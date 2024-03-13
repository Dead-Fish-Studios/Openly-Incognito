@tool
extends Control

var cam: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_node("%MainCamera")
	# connect POI signals
	for poi in get_tree().get_nodes_in_group("POI"):
		poi.switch_level_requested.connect(switch_level)
		poi.camera_zoom_requested.connect(zoom_camera)
	# reset camera upon timeline exit
	Dialogic.timeline_ended.connect(reset_camera)
	
	# start game at Atrium
	switch_level("AtriumLevel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# switch levels
# simply toggles visibility of each level
func switch_level(to_level:StringName):
	print_debug("trying to switch level to: " + to_level)
	
	# turn off visiblity for all levels
	for level in $SubViewportContainer/SubViewport.get_children():
		if level is Camera2D: continue
		level.visible = false
	var target = find_child(to_level)
	if target == null:
		printerr("could not find level \"" + to_level + "\"" )
		return
	
	# turn on visibility for target level
	target.visible = true
	# call init for target level
	target.init_level()
	
	# update HUD info
	$HUD_Layer/HUD.set_location_info(target.level_name)
	
	print_debug("successfully switched level to: " + to_level)

# zoom camera
func zoom_camera(focus: Vector2, zoom: float):
	cam.position = focus
	#cam.zoom = Vector2(2.0, 2.0) * zoom
	create_tween().tween_property(cam, "zoom", Vector2(2.0, 2.0) * zoom, 1.0)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

# reset camera
func reset_camera() -> void:
	# reset properties
	# cam.zoom = Vector2(2.667, 2.667)
	cam.position  = Vector2(240.0, 135.0)
	create_tween().tween_property(cam, "zoom", Vector2(2.667, 2.667), 1.0)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
