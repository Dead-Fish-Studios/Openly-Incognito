@tool
extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO: callbacks for updating InfoHUD contents
func set_location_info(level_name: String):
	$InfoHUD/LocationHUD/LocationInfo.text = level_name
func set_date_info(date: int):
	$InfoHUD/HBoxContainer/DateHUD/DateInfo.text = "Day " + str(date)
func set_time_info(time: Timer):
	pass

