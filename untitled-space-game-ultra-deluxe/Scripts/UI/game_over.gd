extends Node2D


const SIZE_INCREASER: int = 50
const BUTTON_INCREASER: int = 1
const MIN_BUTTON: int = 0
const MAX_BUTTON: int = 2
@export var main_selector: Line2D
@export var buttons: Control
@export var loading_screen: Control
var current_button: int = 0


func _process(delta: float) -> void:
	# Sets currently selected button
	var current_menu_button = buttons.get_child(current_button)
	# Moves UI cursor based on an integer
	main_selector.position.x = (
		current_menu_button.position.x + current_menu_button.size.x + SIZE_INCREASER
	)
	main_selector.position.y = current_menu_button.position.y
	# Move UI Cursor Up
	if Input.is_action_just_pressed("Player_1_Forwards"):
		if current_button > MIN_BUTTON:
			current_button -= BUTTON_INCREASER
	# Move UI Cursor Down
	if Input.is_action_just_pressed("Player_1_Backwards"):
		if current_button < MAX_BUTTON:
			current_button += BUTTON_INCREASER
	if Input.is_action_just_pressed("Player_1_Interact") or Input.is_action_just_pressed("Player_1_Accept"):
		if current_button == 0:
			_load_scene(global.current_save)
		elif current_button == 1:
			get_tree().change_scene_to_file("res://Scenes/UI/nondiegetic_computer_menu.tscn")
		elif current_button == 2:
			get_tree().quit()


func _load_scene(_save_file: int):
	global.current_save = _save_file
	loading_screen.selected_scene = SaveScript._load(_save_file)
	
	loading_screen._start()
	loading_screen.show()
