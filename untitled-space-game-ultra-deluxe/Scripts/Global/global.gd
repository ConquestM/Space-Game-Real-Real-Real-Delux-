extends Node


var multiplayer_on: bool = false
var health: int = 100 : set = _hp_change
var hunger: float = 100 
var thirst: float = 100 
var hp_changing: bool = false
var collected_object: Object = null
var resources: int = 0
var debug_mode: bool = false
var last_player_pos: Vector3
var can_player_move: bool = true
var can_player_move_camera: bool = true
var play_camera_cutscene_1: bool = false
var tutorial_start: bool = false



func _hp_change(_value):
	health = _value
	hp_changing = true
	DamageTaken.start()
