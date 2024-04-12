@tool
extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# toggle "Head Home" button visibility
func go_home_visible(visibility: bool) -> void:
	print_debug("\"go_home\" button visibility set to " + str(visibility))
	%GoHomeButton.visible = visibility

# callback for "head home" button
func go_home_pressed() -> void:
	# check if there is a timeline currently playing
	if Dialogic.current_timeline: return
	# ask player if they want to end the day and head home
	Dialogic.start("res://Timelines/Home.dtl", "confirm_eod")

# region HUD_INFO

# callbacks for updating InfoHUD contents
func set_location_info(level_name: String) -> void:
	$InfoHUD/LocationHUD/LocationInfo.text = level_name
func update_day_info() -> void:
	$InfoHUD/HBoxContainer/DateHUD/DateInfo.text = "Day " + str(Game.inst().get_day())
func update_time_info() -> void:
	$InfoHUD/HBoxContainer/TimeHUD/TimeInfo.text = Game.inst().tod_str()

func set_hover_info(info: String):
	$MouseHUD/MouseHoverInfo.text = info
