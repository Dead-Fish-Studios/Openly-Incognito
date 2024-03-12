@tool
extends Button

@export_group("Display")
@export var item_sprite : Texture2D = preload("res://icon.svg")
@export var item_name : String = "Item Name"

@export_group("Item Info")
@export_multiline var item_description : String = "Short description about this item"
@export var has_dtl: bool = true
@export_file("*.dtl") var item_dtl = "res://Timelines/Items/ph_item_timeline.dtl"
@export var dtl_start_label: String = "inspect"

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = item_sprite
	text = item_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
