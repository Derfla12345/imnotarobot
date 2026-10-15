extends Control


# ****************************************************************************************************
# default captcha methods
var screen: Node2D

func set_screen(new_screen: Node2D):
	screen = new_screen

func advance_and_close_self():
	if (screen and screen.has_method("advance_and_close_captcha")):
		screen.advance_and_close_captcha()
	close_self()

func close_self():
	queue_free()

# ****************************************************************************************************
# specific captcha items
@onready var checkbox = preload("res://Captchas/Scratchoff/check_box.tscn")
@onready var scratchbox = preload("res://Captchas/Scratchoff/scratch_box.tscn")

@onready var checkbox_grid = $CheckBoxGrid
@onready var scratchbox_grid = $ScratchBoxGrid

var correct_checkboxes_toggled: bool = false
var incorrect_checkboxes_toggled: bool = false
var toggle_count: int = 0

var checkbox_row = [[], [], [], []]
var scratchbox_row = [[], [], [], []]

# generates checkboxes and scratchboxes, and their row arrays
# organizes checkboxes into "correct" and "incorrect" arrays to connect to the toggle funcs
func _ready():
	generate_boxes(checkbox, checkbox_row)
	generate_boxes(scratchbox, scratchbox_row)

	var correct_checkboxes = [checkbox_row[1][1], checkbox_row[1][2], checkbox_row[2][1], checkbox_row[2][2]]
	var incorrect_checkboxes = []
	
	# checking each row individually for incorrect checkboxes
	for i in 4: 
		for checkbox_instance in checkbox_row[i]:
			if checkbox_instance not in correct_checkboxes:
				incorrect_checkboxes.append(checkbox_instance)
	
	for checkbox_instance in correct_checkboxes:
		checkbox_instance.toggled.connect(_on_correct_check_box_toggled)
		
	for checkbox_instance in incorrect_checkboxes:
		checkbox_instance.toggled.connect(_on_incorrect_check_box_toggled)
		

# instantiates 16 nodes and organizes them into row arrays so they're easy to manipulate
# ex. access checkbox6 with checkbox_row[1][2]
# also names nodes for debugging purposes
func generate_boxes(node, node_row: Array) -> void:
	for i in 16:
		var node_instance = node.instantiate()
		match node:
			checkbox:
				node_instance.name = "CheckBox%s" % i
				checkbox_grid.add_child(node_instance)
			scratchbox:
				node_instance.name = "ScratchBox%s" % i
				scratchbox_grid.add_child(node_instance)
				node_instance.mouse_filter = Control.MOUSE_FILTER_IGNORE
				node_instance.gui_input.connect(_on_scratch_box_gui_input.bind(node_instance))
			_:
				print("error, unexpected node used in first arg 🤓")
			
		if i <= 3:
			node_row[0].append(node_instance)
		elif i <= 7:
			node_row[1].append(node_instance)
		elif i <= 11:
			node_row[2].append(node_instance)
		elif i <= 15:
			node_row[3].append(node_instance)

# checks if the correct amount of correct checkboxes have been toggled on
func _on_correct_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		toggle_count += 1
		if toggle_count == 4:
			correct_checkboxes_toggled = true
	else:
		toggle_count -= 1
		correct_checkboxes_toggled = false

# checks if any incorrect checkboxes have been toggled on
func _on_incorrect_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		incorrect_checkboxes_toggled = true
	else:
		incorrect_checkboxes_toggled = false

# switches between "scratchoff mode" and "checkbox mode"
func _on_scratch_toggled(toggled_on: bool) -> void:
	if toggled_on:
		scratchbox_grid.mouse_filter = Control.MOUSE_FILTER_STOP	
		for i in 4: 
			for scratchbox_instance in scratchbox_row[i]:
				scratchbox_instance.mouse_filter = Control.MOUSE_FILTER_STOP	
	else:
		scratchbox_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for i in 4: 
			for scratchbox_instance in scratchbox_row[i]:
				scratchbox_instance.mouse_filter = Control.MOUSE_FILTER_IGNORE

# scratchy scratchy
func _on_scratch_box_gui_input(event: InputEvent, node: Control) -> void:
	if event is InputEventMouseButton and event.pressed:
		node.self_modulate.a = node.self_modulate.a / 1.5

# checking if win condition is fulfilled
func _on_submit_button_pressed() -> void:
	if correct_checkboxes_toggled == true and incorrect_checkboxes_toggled == false:
		print("solved")
	else:
		print("failed")
