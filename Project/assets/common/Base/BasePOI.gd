extends Node2D

var button # control button (TextureButton node)
var sprite # sprite (Sprite2D node)
var highlight # highlighting sprite

signal switch_level_requested(to_level:StringName)

# editor properties

@export_category("POI")
@export_group("Camera Zoom In")
# specify camera focus point on screen and zoom level
# upon POI click, camera will zoom in smoothly
# default = no movement
@export var camera_zoom_in_enable:bool = false
@export var camera_zoom:float = 1.0 # camera zoom level
@export_enum("Relative", "Absolute") var camera_focus_mode:int = 0 # defaults to POI location
@export var camera_focus:Vector2 = Vector2(0.0, 0.0) # camera focus location

@export_group("POI Behavior")
# options: 
# 1. open dialogic timeline
# 2. switch to different level
# 3. disable
enum POIMode {OPEN_DIALOGIC_TIMELINE, SWITCH_LEVEL, DISABLED}
@export var POI_mode : POIMode = POIMode.OPEN_DIALOGIC_TIMELINE
@export_file("*.dtl") var dtl_path = "res://assets/common/Dialogic/ph_timeline.dtl"
@export_file("*.tscn") var level_path

# Called when the node enters the scene tree for the first time.
# get children
func _ready():
	button = get_child(0)
	sprite = get_child(1)
	highlight = sprite.get_rect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# handle input
func _input(event):
	# TODO: highlight POI on user demand
	# idea: draw bounding box?
	if event.is_action_pressed("main_gameplay_highlightPOIs"):
		return

# executes juice and desired action
func _on_button_pressed():
	print_debug("POI button pressed:" + self.editor_description)
	# zoom camera
	if camera_zoom_in_enable:
		var maincamera:Camera2D = $"../../../MainCamera"
		maincamera.zoom = Vector2(2.0, 2.0) * camera_zoom
		if camera_focus_mode == 0: # relative
			maincamera.position = self.position + camera_focus
		elif camera_focus_mode == 1: # absolute
			maincamera.position = camera_focus
	
	match POI_mode:
		# option 1: open a dialogic timeline
		POIMode.OPEN_DIALOGIC_TIMELINE:
			print_debug("opening dialogic timeline at " + dtl_path)
			Dialogic.start(dtl_path)
		# option 2: move to another level
		POIMode.SWITCH_LEVEL:
			print_debug("requesting level switch to " + level_path)
			#TODO: switch level
			switch_level_requested.emit(level_path)
		_:
			print_debug("POI button is disabled")
			return
