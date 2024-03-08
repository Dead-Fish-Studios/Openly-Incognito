@tool
extends Node2D

@export_group("First Entered")
@export_file var init_dtl_path

@export_group("Audio")
@export_file var music_path = null
@export_file var env_sfx_path = null

var seen : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	seen = false
	# initialize audio resources
	#if music_path != null:
		#$Music.stream = load(music_path)
	#if env_sfx_path != null:
		#$EnvSFX.stream = load(env_sfx_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# run only when player first enters level
func first_entered() -> void:
	if seen: return
	seen = true
	# open init dialogic timeline
	# use this for establishing levels to player
	Dialogic.start(init_dtl_path)

# runs once every time level is entered
func init_level() -> void:
	first_entered()
	# start audio playback
	#$Music.play()
	#$EnvSFX.play()
	
