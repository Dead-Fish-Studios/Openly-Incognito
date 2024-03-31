@tool
extends Node2D

@export_group("Info")
@export var level_name: String = "Level Name Here"

@export_group("Background")
@export var background_texture: Texture2D = preload("res://assets/common/Base/BG0.png")

@export_group("First Entered")
@export var init_dtl: bool = true
@export_file var init_dtl_path = null

@export_group("Audio")
@export_file var music_path = null
@export_file var env_sfx_path = null

var seen : bool

var musicNode = get_node_or_null("Music")
var sfxNode = get_node_or_null("EnvSFX")

# Called when the node enters the scene tree for the first time.
func _ready():
	seen = false
	
	#initialize background
	$Background/Sprite2D.texture = background_texture
	
	# initialize audio resources
	if music_path != null and musicNode != null:
		$Music.stream = load(music_path)
	if env_sfx_path != null and sfxNode != null:
		$EnvSFX.stream = load(env_sfx_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# run only when player first enters level
func first_entered() -> void:
	if seen: return
	seen = true
	# open init dialogic timeline
	# use this for establishing levels to player
	if init_dtl:
		Dialogic.start(init_dtl_path)

# runs once every time level is entered
func init_level() -> void:
	first_entered()
	# start audio playback
	if music_path != null and musicNode != null:
		$Music.play()
	if env_sfx_path != null and sfxNode != null:
		$EnvSFX.play()

