extends Control
@export var health_bar: Node
@export var delayed_bar: Node
@export var hunger_bar: Node
@export var thirst_bar: Node
@export var resources_count: Node


func _process(_delta: float) -> void:
	delayed_bar.value = global.health
	if global.hp_changing == false:
		health_bar.value = delayed_bar.value
	print(delayed_bar.value)
	global.hunger -= 0.05
	global.thirst -= 0.1
	hunger_bar.value = global.hunger
	thirst_bar.value = global.thirst
	resources_count.text = "Resources: " + str(global.resources)


func _on_button_pressed():
	global.health -= 5
