extends Control
@export var health_bar: Node
@export var delayed_bar: Node


func _process(_delta: float) -> void:
	delayed_bar.value = global.health
	if global.hp_changing == false:
		health_bar.value = delayed_bar.value
	print(delayed_bar.value)


func _on_button_pressed():
	global.health -= 5
