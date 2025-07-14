extends Node2D


const main_game_scene = "res://Scenes/Testing/hunter_test_scene.tscn"
@export var main_buttons: Control
@export var main_selector: Line2D
@export var multiplayer_buttons: Control
@export var multiplayer_selector: Line2D
@export var player_scene: PackedScene
var current_selector: Line2D
var current_menu: String = "Main"
var current_button: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_selector = main_selector


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	current_selector.position.y = current_button * 107
	
	if Input.is_action_just_pressed("Player_1_Forwards"):
		if current_button > 0:
			current_button -= 1
	if Input.is_action_just_pressed("Player_1_Backwards"):
		if current_menu == "Main":
			if current_button < 3:
				current_button += 1
		if current_menu == "Multiplayer":
			if current_button < 2:
				current_button += 1


func _on_singleplayer_pressed() -> void:
	get_tree().change_scene_to_file(main_game_scene)


func _on_multiplayer_pressed() -> void:
	current_menu = "Multiplayer"
	current_selector = multiplayer_selector
	current_button = 0
	main_buttons.hide()
	multiplayer_buttons.show()


func _on_host_pressed() -> void:
	global.multiplayer_on = true
	ConsoleCommands.hosting = true
	get_tree().change_scene_to_file(main_game_scene)


func _on_join_pressed() -> void:
	global.multiplayer_on = true
	ConsoleCommands.joining = true
	get_tree().change_scene_to_file(main_game_scene)
