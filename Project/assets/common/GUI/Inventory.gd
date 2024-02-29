extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide inventory view by default
	$InventoryContainer.visible = false
	$PanelContainer.visible = false
	# display default text in inventory description box
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
		print_debug("inventory button toggled on - open inventory")
		# update inventory items from Dialogic
		update_inventory()
		# show inventory panel
		$InventoryContainer.visible = true
		$PanelContainer.visible = true
	else:
		print_debug("inventory button toggled off - close inventory")
		$InventoryContainer.visible = false
		$PanelContainer.visible = false

# callback for item buttons
# inspect items in inventory
# upon pressing item button in inventory 
# 	i.e. $"InventoryContainer/ScrollContainer/ItemIconsGrid" children
# display item description text in bottom panel 
# 	i.e. $"InventoryContainer/PanelContainer/ItemText".text
func _on_item_button_pressed(emitter: NodePath):
	print_debug("item button pressed:  "+ emitter.get_concatenated_names())
	# get ref to emitter node (item button)
	var item_button = get_node(emitter)
	# get item name
	var item_name = item_button.name
	# get item description text
	var item_description = item_button.editor_description
	# display in bottom text box
	$"PanelContainer/ItemText".text \
		= item_name + '\n' + item_description

# callback for variable changes in Dialogic
func _on_Dialogic_var_change(info:Dictionary):
	update_inventory()
