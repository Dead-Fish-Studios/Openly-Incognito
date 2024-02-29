extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# switch levels
func _on_switch_level_requested(to_level:StringName):
	print_debug("trying to switch level to: " + to_level)
	get_tree().change_scene_to_file(to_level)
