extends Node2D


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
	main_selector.position.x = (current_menu_button.position.x + current_menu_button.size.x + 50)
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
	current_menu = 4
	main_buttons.hide()
	save_files.show()


func _on_multiplayer_pressed() -> void:
	current_menu = 1
	main_buttons.hide()
	multiplayer_buttons.show()


func _on_host_pressed() -> void:
	global.multiplayer_on = true
	Online.hosting = true
	_load_scene(0, TUTORIAL_SCENE)


func _on_join_pressed() -> void:
	global.multiplayer_on = true
	Online.joining = true
	_load_scene(0, TUTORIAL_SCENE)


func _load_scene(_save_file: int, selected_scene):
	loading_screen.selected_scene = selected_scene
	loading_screen._start()
	loading_screen.show()


func _back():
	current_button[current_menu] = 0
	if current_menu == 1:
		current_menu = 0
		main_buttons.show()
		multiplayer_buttons.hide()
	elif current_menu == 2 or current_menu == 3:
		current_menu = 1
		multiplayer_inputer_join.hide()
		multiplayer_inputer_host.hide()
		multiplayer_buttons.show()
	elif current_menu == 4:
		current_menu = 0
		main_buttons.show()
		save_files.hide()


func _enter():
	# Main Menu UI
	if current_menu == 0:
		if current_button[current_menu] == 0:
			_on_singleplayer_pressed()
		elif current_button[current_menu] == 1:
			_on_multiplayer_pressed()
		elif current_button[current_menu] == 2:
			return
		elif current_button[current_menu] == 3:
			return
	# Multiplayer Menu UI
	elif current_menu == 1:
		if current_button[current_menu] == 0:
			_on_host_menu_pressed()
		elif current_button[current_menu] == 1:
			_on_join_menu_pressed()
		elif current_button[current_menu] == 2:
			_back()
	# Joining Menu Stuff
	elif current_menu == 2:
		if current_button[current_menu] == 0:
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
		elif current_button[current_menu] == 1:
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
		elif current_button[current_menu] == 2:
			_on_join_pressed()
		elif current_button[current_menu] == 3:
			_back()
	# Hosting Menu Stuff
	elif current_menu == 3:
		if current_button[current_menu] == 0:
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
		elif current_button[current_menu] == 1:
			_on_host_pressed() 
		elif current_button[current_menu] == 2:
			_back()
	# Save File Menu Stuff
	elif current_menu == 4:
		if current_button[current_menu] == 0:
			_load_scene(0, SaveData1.current_room)
		if current_button[current_menu] == 1:
			_load_scene(0, SaveData2.current_room)
		if current_button[current_menu] == 2:
			_load_scene(0, SaveData3.current_room)
		elif current_button[current_menu] == 3:
			_back()
	_get_max_menu_buttons()


func _on_join_menu_pressed() -> void:
	current_menu = 2
	multiplayer_buttons.hide()
	multiplayer_inputer_join.show()
	menu_gap_size = 214


func _on_host_menu_pressed() -> void:
	current_menu = 3
	multiplayer_buttons.hide()
	multiplayer_inputer_host.show()
	menu_gap_size = 214


func _get_max_menu_buttons():
	max_button = -1
	for i in menus[current_menu].get_children():
		max_button += 1
