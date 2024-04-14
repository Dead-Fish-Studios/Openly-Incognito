@tool
extends Node2D

@export_group("Info")
@export var level_name: String = "Level Name Here"

@export_group("Background")
@export var background_texture: Texture2D = preload("res://assets/common/Base/BG0.png")

@export_group("First Entered")
@export var init_dtl: bool = true
@export_file var init_dtl_path = null
@export var init_dtl_label: String = "start"

var seen : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	seen = false
	
	#initialize background
	$Background/Sprite2D.texture = background_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# runs once every time level is entered
func init_level() -> void:
	if !Dialogic.current_timeline:
		if init_dtl and init_dtl_path != null:
			if init_dtl_label != "start":
				Dialogic.start(init_dtl_path, init_dtl_label)
			else: Dialogic.start(init_dtl_path)
		
func set_background(path) -> void:
	background_texture = load(path)
	$Background/Sprite2D.texture = background_texture
	
