extends Node


var multiplayer_on: bool = false
var health: int = 100 : set = _hp_change
var hunger: float = 100 
var thirst: float = 100 
var hp_changing: bool = false
var collected_object: Object = null
var resources: int = 0
var debug_mode: bool = false
var last_player_pos: Vector3 = Vector3(0, 10, 0)
var can_player_move: bool = true


func _hp_change(_value):
	health = _value
	hp_changing = true
	DamageTaken.start()
