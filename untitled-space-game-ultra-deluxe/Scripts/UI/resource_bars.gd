extends Control
@export var healthbar: Node


func _process(_delta: float) -> void:
	healthbar.value = global.health
	global.health += 1
	print(healthbar.value)
