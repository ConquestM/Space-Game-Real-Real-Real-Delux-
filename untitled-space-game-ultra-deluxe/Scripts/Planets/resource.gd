extends StaticBody3D

const ROTATE_AMOUNT: int = 1
const RESOURCE_VALUE: int = 1
const FOOD_VALUE: int = 10
const WATER_VALUE: int = 10

@export var resource: Node
@export var max_float_height: float = 1.75
@export var min_float_height: float = 2.25

var float_height_varitaion: float = 0.05
var id = get_instance_id()
var float_height: float = 2.6


func _process(_delta: float) -> void:
	# Gives the player things when collected
	if global.collected_object == instance_from_id(id):
		global.resources += RESOURCE_VALUE
		global.hunger += FOOD_VALUE
		global.thirst += WATER_VALUE
		global.collected_object = null
		# Deletes itself
		queue_free()
		if get_tree().current_scene.name != "Tutorial":
			get_parent()._spawnher()
	# Makes it spin
	if has_meta("spin"):
		rotation_degrees.y += ROTATE_AMOUNT
		position.y = lerp(position.y, float_height, _delta)
		if position.y >= min_float_height - float_height_varitaion:
			float_height = max_float_height
		if position.y <= max_float_height + float_height_varitaion:
			float_height = min_float_height
