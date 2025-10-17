extends Control

const HUNGER_DRAIN: float = 0.025
const THIRST_DRAIN: float = 0.03

@export var health_bar: Node
@export var delayed_bar: Node
@export var hunger_bar: Node
@export var thirst_bar: Node
@export var resources_count: Node


func _process(_delta: float) -> void:
	# Sets the real hp bar to health
	delayed_bar.value = global.health
	# If the player stops taking damage, the health bar is updated to match real hp
	if global.hp_changing == false:
		health_bar.value = delayed_bar.value
	if global.debug_mode:
		print(delayed_bar.value)
	# Drains hunger and thirst
	global.hunger -= HUNGER_DRAIN
	global.thirst -= THIRST_DRAIN
	# Displays hunger and thirst on the bars
	hunger_bar.value = global.hunger
	thirst_bar.value = global.thirst
	resources_count.text = "Resources: " + str(global.resources)
