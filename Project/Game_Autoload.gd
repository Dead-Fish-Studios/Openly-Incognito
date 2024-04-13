extends Node

var game: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_node("/root/Main")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# switch levels
func switch_level(to_level:String):
	game.switch_level(to_level)

# zoom camera
func zoom_camera_xy(focus_x: float, focus_y: float, zoom: float):
	zoom_camera(Vector2(focus_x, focus_y), zoom)

func zoom_camera(focus: Vector2, zoom: float):
	game.zoom_camera(focus, zoom)

# reset camera
func reset_camera() -> void:
	game.reset_camera()

# find a specified POI in a certain level
func find_POI(level: String, POI: String) -> Variant:
	return game.find_POI(level, POI)

# set POI visibility
func set_POI_visible(level: String, POI: String, is_visible: bool):
	game.set_POI_visible(level, POI, is_visible)

func set_level_init_label(level: String, label: String):
	game.set_level_init_label(level, label)

# set POI timeline start label
func set_POI_label(level: String, POI: String, label: String):
	game.set_POI_label(level, POI, label)

# get POI timeline start label
func get_POI_label(level: String, POI: String) -> String:
	return game.get_POI_label(level, POI)

# region INGAME_TIME

# initialize time and day
func reset_time_and_day() -> void:
	game.reset_time_and_day()

# reset time to start of day
func reset_time() -> void:
	game.reset_time()

# get current time of day
func get_time() -> int:
	return game.get_time()

# get current day
func get_day() -> int:
	return game.get_day()

# get time of day in string
func tod_str(_24hr: bool = false) -> StringName:
	return game.tod_str(_24hr)

# progress time by specified amount
func tod_progress(minutes: int) -> void:
	game.tod_progress(minutes)

# end the day and start new day
func sleep() -> void:
	game.sleep()

# toggle "Head Home" button visibility
func go_home_visible(visibility: bool) -> void:
	game.go_home_visible(visibility)

# get game instance
func inst() -> Game:
	return game

# get HUD
func HUD() -> Control:
	return game.hud

# change background
func change_level_background(level: String, path: String) -> void:
	return game.change_level_background(level, path)
	
# get current POI visibility
func get_POI_visible(level: String, POI: String) -> bool:
	return game.get_POI_visible(level, POI)
	
# toggle the visibility of a POI
func toggle_POI_visible(level: String, POI: String) -> void:
	return game.toggle_POI_visible(level, POI)
