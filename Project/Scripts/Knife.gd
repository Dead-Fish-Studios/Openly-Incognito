extends Sprite2D

var labelVisible

# Called when the node enters the scene tree for the first time.
func _ready():
	if Dialogic.VAR.RecievedKnife == false:
		visible = false
	else:
		visible = true
	$Label.scale = Vector2(1,1)/scale
	$Label.visible = false
	labelVisible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible == false:
		var gotPass = Dialogic.VAR.RecievedKnife
		if gotPass == true:
			visible = true

func _input(event):
	if event is InputEventMouseButton:
		var pos = get_viewport().get_mouse_position()
		var x = position.x
		var y = position.y
		var width = texture.get_width() * scale[0]
		var height = texture.get_height() * scale[1]
		if pos[0] > x - width/2 and pos[1] > y - height/2 and pos[0] < x + width/2 and pos[1] < y + height/2 and visible == true:
			if labelVisible:
				hideLabel()
				labelVisible = false
			else:
				showLabel()
				labelVisible = true

func hideLabel():
	$"../Book".visible = false
	$Label.visible = false
	
func showLabel():
	hideAllLabels()
	$"../Book".visible = true
	$Label.visible = true

func hideAllLabels():
	$"../Book".visible = false
	$"../Password/Label".visible = false
	$"../Key/Label".visible = false
	$"../Knife/Label".visible = false
