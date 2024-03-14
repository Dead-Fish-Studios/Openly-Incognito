@tool
extends Control

var cam: Camera2D
var POIs: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = $SubViewportContainer/SubViewport/MainCamera
	# populate POI dictionary
	for level in $SubViewportContainer/SubViewport.get_children():
		if level is Camera2D: continue
		POIs[level.name] = level.get_child(1).get_children()
		for poi in POIs[level.name]:
			# connect POI signals
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
# @param to_level: node name of target level 
func switch_level(to_level:String):
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
	
	# reset camera
	reset_camera()
	
	print_debug("successfully switched level to: " + to_level)
	print(get_tree_string())

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

# find a specified POI in a certain level
func find_POI(level: String, POI: String) -> Variant:
	var targetPOI = get_node("SubViewportContainer/SubViewport/"+level+"/POIs/"+POI)
	if targetPOI == null:
		printerr("could not find POI " + POI + " in level " + level)
	return targetPOI

# set POI visibility
# use to spawn / despawn POIs from levels
func set_POI_visible(level: String, POI: String, is_visible: bool):
	var targetPOI = find_POI(level, POI)
	if targetPOI == null: return
	targetPOI.visible = is_visible
	print_debug(level+"-"+POI+ " : set visibility to " + ("true" if is_visible else "false"))

# set POI timeline start label
func set_POI_label(level: String, POI: String, label: String):
	var targetPOI = find_POI(level, POI)
	if targetPOI == null: return
	targetPOI.dtl_start_label = label
	print_debug(level+"-"+POI+ " : set label to " + label)

# get POI timeline start label
func get_POI_label(level: String, POI: String) -> String:
	var targetPOI = find_POI(level, POI)
	if targetPOI == null: return "error"
	return targetPOI.dtl_start_label
