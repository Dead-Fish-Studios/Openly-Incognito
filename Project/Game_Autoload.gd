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

# set POI timeline start label
func set_POI_label(level: String, POI: String, label: String):
	game.set_POI_label(level, POI, label)

# get POI timeline start label
func get_POI_label(level: String, POI: String) -> String:
	return game.get_POI_label(level, POI)

# get game instance
func inst() -> Game:
	return game

# get HUD
func HUD() -> Control:
	return game.hud