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

@export var checkbox_grid: GridContainer
@export var scratchbox_grid: GridContainer

var solved: bool = false
var checkbox_is_correct: bool = false
var cb_row = [[], [], [], []]
var sb_row = [[], [], [], []]

func _ready():
	generate_boxes(checkbox, cb_row)
	generate_boxes(scratchbox, sb_row)
	scratchbox_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cb_row[0][0].toggled.connect(_on_check_box_toggled)

# instantiates 16 nodes and organizes them into row arrays so they're easy to manipulate
# ex. access checkbox6 with cb_row[1][2]
func generate_boxes(node, node_row: Array) -> void:
	for i in 16:
		var node_instance = node.instantiate()
		if node == checkbox:
			node_instance.name = "CheckBox%s" % i
			checkbox_grid.add_child(node_instance)
		else:
			node_instance.name = "Scratchbox%s" % i
			scratchbox_grid.add_child(node_instance)
			node_instance.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
		if node_instance.name == "CheckBox0":
			checkbox_is_correct = true
			
		if i <= 3:
			node_row[0].append(node_instance)
		elif i <= 7:
			node_row[1].append(node_instance)
		elif i <= 11:
			node_row[2].append(node_instance)
		elif i <= 15:
			node_row[3].append(node_instance)

func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		solved = true
	else:
		solved = false

func _on_scratch_toggled(toggled_on: bool) -> void:
	if toggled_on:
		scratchbox_grid.mouse_filter = Control.MOUSE_FILTER_STOP	
	else:
		scratchbox_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_submit_button_pressed() -> void:
	if solved:
		print("solved")
	else:
		print("failed")
