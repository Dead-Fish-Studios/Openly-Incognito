@tool
extends Node2D

signal switch_level_requested(to_level:StringName)
signal camera_zoom_requested(focus: Vector2, zoom: float)

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
@export var POI_button_icon : Texture2D = preload("res://assets/common/GUI/icons/POI_inspect.png")
@export var POI_button_offset : Vector2 = Vector2(0.0, -60.0)
@export_file("*.dtl") var dtl_path = "res://assets/common/Dialogic/ph_timeline.dtl"
@export var dtl_start_label: String = "start"

@export_subgroup("Days Enabled")
# spawn this POI only on these days
# default = all four days
@export_flags("Day1:1", "Day2:2", "Day3:4", "Day4:8") var days_flags: int = 0b1111

@export_group("Sprite")
@export var POI_sprite_enable : bool = true
@export var POI_sprite : Texture2D = preload("res://assets/common/Base/_ph_POISprite.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("POI")
	# connect callback for start of day
	if not Engine.is_editor_hint():
		Game.inst().day_started.connect(_on_day_start)
	# set sprite
	$Sprite2D.texture = POI_sprite if POI_sprite_enable else null
	# set button icon
	$TextureButton.texture_normal = POI_button_icon
	# set button offset
	$TextureButton.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	$TextureButton.position = $TextureButton.size / -2.0 + POI_button_offset

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
	print_debug("POI button pressed:" + self.name)
	
	# zoom camera
	if camera_zoom_in_enable:
		camera_zoom_requested.emit(camera_focus + (self.position if camera_focus_mode == 0 else Vector2(0.0, 0.0)), camera_zoom * 2.0)
	
	# open DTL
	if dtl_start_label == "start": Dialogic.start(dtl_path)
	else: Dialogic.start(dtl_path, dtl_start_label)

# initialization at start of each new day
func _on_day_start(day: int) -> void:
	# set visibility (bit mask from days_flags)
	self.visible = bool( (1 << (day-1)) & days_flags )