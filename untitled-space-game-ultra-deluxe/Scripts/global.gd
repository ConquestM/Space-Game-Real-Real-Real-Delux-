extends Node
var health: int = 100 : set = _hp_change
var hp_changing: bool = false

func _hp_change(_value):
	health = _value
	hp_changing = true
	await get_tree().create_timer(1.0).timeout
	hp_changing = false
