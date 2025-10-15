extends Node2D

const SIZE_INCREASER: int = 50
const MENU_GAP_SIZE_SETTER: int = 214
const CURRENT_MENU: Array = [
	0,
	1,
	2,
	3,
	4,
	5
]
# Saved Scenes
const TEST_GAME_SCENE = "res://Scenes/Testing/hunter_test_scene.tscn"
const TUTORIAL_SCENE = "res://Scenes/Gameplay Scenes/Non-Planetoid/tutorial.tscn"
# In Scene Stuff
@export var main_selector: Line2D
@export var main_buttons: Control
@export var multiplayer_buttons: Control
@export var multiplayer_inputer_join: Control
@export var multiplayer_inputer_host: Control
@export var save_files: Control
@export var loading_screen: Control
# Menuing Stuff
var current_menu: int = 0
var menus: Array
var main_current_button: int = 0
var multiplayer_current_button: int = 0
var multiplayer_inputer_join_button: int = 0
var multiplayer_inputer_host_button: int = 0
var save_file_button: int = 0
var current_button: Array = [
	main_current_button, 
	multiplayer_current_button,
	multiplayer_inputer_join_button,
	multiplayer_inputer_host_button,
	save_file_button
]
var min_button: int = 0
var max_button: int = 3
var button_increaser: int = 1
var menu_gap_size = 107
var loading_progress: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menus = [
		main_buttons,
		multiplayer_buttons,
		multiplayer_inputer_join,
		multiplayer_inputer_host,
		save_files
	]
	_get_max_menu_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_menu_button = menus[current_menu].get_child(current_button[current_menu])
	main_selector.position.x = (
		current_menu_button.position.x + current_menu_button.size.x + SIZE_INCREASER
	)
	main_selector.position.y = current_menu_button.position.y
	
	# Move UI Cursor Up
	if Input.is_action_just_pressed("Player_1_Forwards"):
		if current_button[current_menu] > min_button:
			current_button[current_menu] -= button_increaser
	# Move UI Cursor Down
	if Input.is_action_just_pressed("Player_1_Backwards"):
		if current_button[current_menu] < max_button:
			current_button[current_menu] += button_increaser
	# Select Current UI
	if Input.is_action_just_pressed("Player_1_Accept"):
		_enter()


func _on_singleplayer_pressed() -> void:
	current_menu = CURRENT_MENU[4]
	main_buttons.hide()
	save_files.show()


func _on_multiplayer_pressed() -> void:
	current_menu = CURRENT_MENU[1]
	main_buttons.hide()
	multiplayer_buttons.show()


func _on_host_pressed() -> void:
	global.multiplayer_on = true
	Online.hosting = true
	_load_scene(CURRENT_MENU[1])


func _on_join_pressed() -> void:
	global.multiplayer_on = true
	Online.joining = true
	_load_scene(CURRENT_MENU[1])


func _load_scene(_save_file: int):
	global.current_save = _save_file
	loading_screen.selected_scene = SaveScript._load(_save_file)
	
	loading_screen._start()
	loading_screen.show()


func _back():
	current_button[current_menu] = CURRENT_MENU[0]
	if current_menu == CURRENT_MENU[1]:
		current_menu = CURRENT_MENU[0]
		main_buttons.show()
		multiplayer_buttons.hide()
	elif current_menu == CURRENT_MENU[2] or current_menu == CURRENT_MENU[3]:
		current_menu = CURRENT_MENU[1]
		multiplayer_inputer_join.hide()
		multiplayer_inputer_host.hide()
		multiplayer_buttons.show()
	elif current_menu == CURRENT_MENU[4]:
		current_menu = CURRENT_MENU[0]
		main_buttons.show()
		save_files.hide()


func _enter():
	# Main Menu UI
	if current_menu == CURRENT_MENU[0]:
		if current_button[current_menu] == CURRENT_MENU[0]:
			_on_singleplayer_pressed()
		elif current_button[current_menu] == CURRENT_MENU[1]:
			_on_multiplayer_pressed()
		elif current_button[current_menu] == CURRENT_MENU[2]:
			return
		elif current_button[current_menu] == CURRENT_MENU[3]:
			get_tree().quit()
	# Multiplayer Menu UI
	elif current_menu == CURRENT_MENU[1]:
		if current_button[current_menu] == CURRENT_MENU[0]:
			_on_host_menu_pressed()
		elif current_button[current_menu] == CURRENT_MENU[1]:
			_on_join_menu_pressed()
		elif current_button[current_menu] == CURRENT_MENU[2]:
			_back()
	# Joining Menu Stuff
	elif current_menu == CURRENT_MENU[2]:
		if current_button[current_menu] == CURRENT_MENU[0]:
			if not multiplayer_inputer_join.get_node("IP/IP Input").has_focus():
				# Grab Text Input's Focus
				multiplayer_inputer_join.get_node("IP/IP Input").grab_focus()
			else:
				# Removes the indented line made by the player
				multiplayer_inputer_join.get_node("IP/IP Input").remove_line_at(1)
				# Removes Text Input's Focus
				multiplayer_inputer_join.get_node("IP/IP Input").release_focus()
				Online.inputedip = multiplayer_inputer_join.get_node("IP/IP Input").text
				print(Online.inputedip)
		elif current_button[current_menu] == CURRENT_MENU[1]:
			if not multiplayer_inputer_join.get_node("Port/Port Input").has_focus():
				# Grab Text Input's Focus
				multiplayer_inputer_join.get_node("Port/Port Input").grab_focus()
			else:
				# Removes the indented line made by the player
				multiplayer_inputer_join.get_node("Port/Port Input").remove_line_at(1)
				# Removes Text Input's Focus
				multiplayer_inputer_join.get_node("Port/Port Input").release_focus()
				Online.port = multiplayer_inputer_join.get_node("Port/Port Input").text
				print(Online.port)
		elif current_button[current_menu] == CURRENT_MENU[2]:
			_on_join_pressed()
		elif current_button[current_menu] == CURRENT_MENU[3]:
			_back()
	# Hosting Menu Stuff
	elif current_menu == CURRENT_MENU[3]:
		if current_button[current_menu] == CURRENT_MENU[0]:
			if not multiplayer_inputer_host.get_node("Port/Port Input").has_focus():
				# Grab Text Input's Focus
				multiplayer_inputer_host.get_node("Port/Port Input").grab_focus()
			else:
				# Removes the indented line made by the player
				multiplayer_inputer_host.get_node("Port/Port Input").remove_line_at(1)
				# Removes Text Input's Focus
				multiplayer_inputer_host.get_node("Port/Port Input").release_focus()
				Online.port = multiplayer_inputer_host.get_node("Port/Port Input").text
				print(Online.port)
		elif current_button[current_menu] == CURRENT_MENU[1]:
			_on_host_pressed() 
		elif current_button[current_menu] == CURRENT_MENU[2]:
			_back()
	# Save File Menu Stuff
	elif current_menu == CURRENT_MENU[4]:
		if current_button[current_menu] == CURRENT_MENU[0]:
			_load_scene(1)
		if current_button[current_menu] == CURRENT_MENU[1]:
			_load_scene(2)
		if current_button[current_menu] == CURRENT_MENU[2]:
			_load_scene(3)
		elif current_button[current_menu] == CURRENT_MENU[3]:
			_back()
	_get_max_menu_buttons()


func _on_join_menu_pressed() -> void:
	current_menu = CURRENT_MENU[2]
	multiplayer_buttons.hide()
	multiplayer_inputer_join.show()
	menu_gap_size = MENU_GAP_SIZE_SETTER


func _on_host_menu_pressed() -> void:
	current_menu = CURRENT_MENU[3]
	multiplayer_buttons.hide()
	multiplayer_inputer_host.show()
	menu_gap_size = MENU_GAP_SIZE_SETTER


func _get_max_menu_buttons():
	max_button = -CURRENT_MENU[1]
	for i in menus[current_menu].get_children():
		max_button += CURRENT_MENU[1]
