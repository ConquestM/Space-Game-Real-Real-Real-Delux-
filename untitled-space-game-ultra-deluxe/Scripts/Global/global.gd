extends Node


var multiplayer_on: bool = false
var health: int = 100 : set = _hp_change
var hunger: float = 100 
var thirst: float = 100 
var hp_changing: bool = false
var collected_object: Object = null
var resources: int = 0
var debug_mode: bool = true
var last_player_pos: Vector3
var can_player_move: bool = true
var can_player_move_camera: bool = true
var play_camera_cutscene_1: bool = false
var current_save: int = 1
var current_scene: String = "res://Scenes/Gameplay Scenes/Non-Planetoid/tutorial.tscn"
var exitspaceui: bool = false
var player: Node = null
var can_player_interact: bool = true
var loading_screen_active: bool = false

func _hp_change(_value):
	health = _value
	hp_changing = true
	DamageTaken.start()
