@tool
extends Control

var cam: Camera2D
var POIs: Dictionary
var hud: Control
var day: int :
	set(_day):
		day = _day
		hud.update_day_info()
		Dialogic.VAR.OTHER.Day = _day
		print_debug("day set to : " + str(day))

var time_of_day: int :# time of day (in minutes)
	set(_time):
		time_of_day = _time
		hud.update_time_info()
		Dialogic.VAR.OTHER.Time = _time
		# check EOD
		if time_of_day >= end_of_day_time && eod == false:
			eod = true
			_eod_reached()
var time_of_day_target: int # tod tweening
var eod := false

# time signals
signal day_started(day: int)

@export var cam_offset: Vector2 = Vector2(-20.0, 0.0)
@export var fade_time: float = 0.7

@export_group("Game Time")
@export var starting_day: int = 1 # for debug purposes
@export var start_of_day_time: int = 9 * 60 # 09:00 AM
@export var end_of_day_time: int = 17 * 60 # 05:00 PM

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = $SubViewportContainer/SubViewport/MainCamera
	hud = $HUD_Layer/HUD
	# populate POI dictionary
	for level in $SubViewportContainer/SubViewport.get_children():
		if level is Camera2D: continue
		var POIs_node = level.get_child(1)
		if POIs_node != null:
			POIs[level.name] = POIs_node.get_children()
			for poi in POIs[level.name]:
				# connect POI signals
				poi.switch_level_requested.connect(switch_level)
				poi.camera_zoom_requested.connect(zoom_camera)
	# reset camera upon timeline exit
	Dialogic.timeline_ended.connect(reset_camera)
	
	# initialize time
	reset_time_and_day()
	# emit start of day signal
	day_started.emit(day)

	# start game at Atrium
	switch_level("HomeMorningLevel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# switch levels
# simply toggles visibility of each level
# @param to_level: node name of target level 
func switch_level(to_level:String, fade: bool = true):
	print_debug("trying to switch level to: " + to_level)
	
	if fade:
		# fade out to black
		var fade_tweener: Tween = create_tween()
		fade_tweener.tween_property($HUD_Layer/Curtains, "color", Color(0,0,0,1), fade_time )
		await fade_tweener.finished

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
	
	# update HUD info
	hud.set_location_info(target.level_name)
	hud.set_hover_info("")
	
	# fade in from black
	if fade:
		var fade_tweener: Tween = create_tween()
		print($HUD_Layer/Curtains.color)
		fade_tweener.tween_property($HUD_Layer/Curtains, "color", Color(0,0,0,0), fade_time )
		await fade_tweener.finished
	
	# call init for target level
	target.init_level()

	# reset camera
	reset_camera()
	
	print_debug("successfully switched level to: " + to_level)

# region CAMERA

# zoom camera
func zoom_camera(focus: Vector2, zoom: float):
	cam.position = focus + cam_offset
	#cam.zoom = Vector2(2.0, 2.0) * zoom
	create_tween().tween_property(cam, "zoom", Vector2(2.0, 2.0) * zoom, 1.0)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	# play SFX
	$Audio/SFX/cam_zoom.play()

# reset camera
func reset_camera() -> void:
	# reset properties
	# cam.zoom = Vector2(2.667, 2.667)
	cam.position  = Vector2(240.0, 135.0)
	create_tween().tween_property(cam, "zoom", Vector2(2.667, 2.667), 1.0)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	#play SFX
	$Audio/SFX/cam_reset.play()

# region POI

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

# set level init timeline label
func set_level_init_label(level: String, label: String):
	get_node("SubViewportContainer/SubViewport/"+level).init_dtl_label = label
	print_debug(level+" : set init label to "+label)

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

# display info for POI upon mouse hover
func POI_hover_info(entered: bool, hover_info: String = ""):
	if entered:
		if hover_info != "":
			hud.set_hover_info(hover_info)
	else: hud.set_hover_info("")

# region INGAME_TIME

# initialize time and day
func reset_time_and_day() -> void:
	reset_time()
	day = starting_day
	print_debug("time and day reset to Day " + str(get_day()) + " / " + tod_str()) 

# reset time to start of day
func reset_time() -> void:
	time_of_day = start_of_day_time
	time_of_day_target = time_of_day
	eod = false
	hud.update_time_info()
	hud.go_home_visible(false)
	print_debug("TOD reset to " + tod_str()) 

# get current time of day
func get_time() -> int:
	return time_of_day

# get current day
func get_day() -> int:
	return day

# get time of day in string
func tod_str(_24hr: bool = false) -> StringName:
	var hour: int = time_of_day / 60
	var minute: StringName = ("0" if (time_of_day % 60 < 10) else "") + str(time_of_day % 60)
	if _24hr: return str(hour) + ":" + minute
	else: return str(hour - (12 if hour > 12 else 0)) + ":" + minute + (" AM" if hour < 12 else " PM")

# progress time by specified amount
func tod_progress(minutes: int, _tween: bool = true) -> void:
	# sanity check - do not allow time to go past 24:00 without sleep()
	if time_of_day + minutes >= 24 * 60:
		printerr("time of day incremented past 24:00")
		return
	
	# increment TOD
	time_of_day_target += minutes
	if _tween: create_tween().tween_property(self, "time_of_day", time_of_day_target, 20)
	else: time_of_day = time_of_day_target
	print_debug("in game time progressed by " + str(minutes) + " to : " \
		+ str(time_of_day) + " ( " + tod_str() + " )")

# callback for when end of day is reached
func _eod_reached() -> void:
	print_debug("EOD reached: time is " + tod_str())
	# make "head home" HUD button visible
	hud.go_home_visible(true)

# end the day and init new day
func sleep() -> void:
	print_debug("Ended Day " + str(day) + ", progressing to next day")
	# fade to black
	var fade_tweener: Tween = create_tween()
	fade_tweener.tween_property($HUD_Layer/Curtains, "color", Color(0,0,0,1), 10 )
	set_process_input(false)
	await fade_tweener.finished
	set_process_input(true)
	# reset time
	reset_time()
	# increment day
	day += 1
	# emit start of day signal
	day_started.emit(day)
	# set day in dialogic vars
	Dialogic.VAR.OTHER.Day = day
	# fade in
	switch_level("HomeMorningLevel")

# toggle "Head Home" button visibility
func go_home_visible(visibility: bool) -> void:
	hud.go_home_visible(visibility)
	
# change the background of the level
func change_level_background(level: String, path: String) -> void:
	var targetLevel = get_node("SubViewportContainer/SubViewport/"+level)
	targetLevel.set_background(path)
	
# get current POI visibility
func get_POI_visible(level: String, POI: String) -> bool:
	var targetPOI = find_POI(level, POI)
	return targetPOI.visible
	
# toggle the visibility of a POI
func toggle_POI_visible(level: String, POI: String) -> void:
	var targetPOI = find_POI(level, POI)
	var current_visibility = targetPOI.visible
	targetPOI.visible = !current_visibility

