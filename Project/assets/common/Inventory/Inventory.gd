@tool
extends VBoxContainer

var item_inspect_dtl: String

@export_multiline var item_description_noselect ="""this is your inventory.
click on an item above to learn more."""
@export_node_path("RichTextLabel") var item_text_box = ^"HBoxContainer/PanelContainer/ItemText"
@export_node_path("Button") var inspect_button = ^"HBoxContainer/InspectItemButton"

var selected_item # currently selected item

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide inventory view by default
	_on_inventory_button_toggled(false)
	# connect all item buttons' signals to callback _on_item_button_pressed()
	for item_button in $"InventoryContainer/ScrollContainer/ItemIconsGrid".get_children():
		item_button.pressed.connect(_on_item_button_pressed.bind(item_button.get_path()))
	# connect callback to update inventory upon Dialogic var changes
	Dialogic.VAR.variable_changed.connect(_on_Dialogic_var_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# query Dialogic variables to update entire inventory grid 
func update_inventory():
	# iterate thru all items
	for item_button in $"InventoryContainer/ScrollContainer/ItemIconsGrid".get_children():
		# hide by default
		item_button.visible = false
		# get item name
		var item_id = item_button.name
		# if item is in player posession, enable button (make visible)
		# query Dialogic
		if not Dialogic.VAR.ITEMS.has(item_id):
			printerr("Inventory: could not find item " + item_id + " in Dialogic.VAR.ITEMS")
		elif Dialogic.VAR.ITEMS.get(item_id) == true: 
			# item is in inventory -> make visible
			item_button.visible = true
	print_debug("updated inventory")

# open and close inventory
func _on_inventory_button_toggled(toggled_on):
	if toggled_on:
		# update inventory items from Dialogic
		update_inventory()
		# reset desciption text
		get_node(item_text_box).text \
			= item_description_noselect
		# hide inspect button by default
		get_node(inspect_button).visible = false
		# show inventory
		for node in get_children():
			node.visible = true
	else:
		# hide inventory
		for node in get_children():
			node.visible = false
	# always display inventory button
	$InventoryButton.visible = true

# callback for item buttons
# inspect items in inventory
func _on_item_button_pressed(emitter: NodePath):
	# get ref to emitter node (item button)
	selected_item = get_node(emitter)
	# display item info in bottom text box
	get_node(item_text_box).text \
		= "[b]" + selected_item.item_name + "[/b]" + '\n' + selected_item.item_description
	# if item has dialogic timeline attached,
	# display button to open timeline
	get_node(inspect_button).visible = selected_item.has_dtl

# callback for variable changes in Dialogic
func _on_Dialogic_var_change(_info:Dictionary):
	update_inventory()

func _on_inspect_item_button_pressed():
	# check if dialogic timeline is already open
	if Dialogic.current_timeline:
		# TODO: display some error message / sfx to player
		return
	# open inspect DTL
	Dialogic.start(selected_item.item_dtl, selected_item.dtl_start_label)
