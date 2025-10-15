extends StaticBody3D

const ROTATE_AMOUNT: int = 1
@export var resource: Node
@export var max_float_height: float = 1.75
@export var min_float_height: float = 2.25
var float_height_varitaion: float = 0.05
var id = get_instance_id()
var float_height: float = 2.6


func _process(_delta: float) -> void:
	if global.collected_object == instance_from_id(id):
		global.resources += ROTATE_AMOUNT
		global.collected_object = null
		queue_free()
		get_parent()._spawnher()
	if has_meta("spin"):
		rotation_degrees.y += ROTATE_AMOUNT
		position.y = lerp(position.y, float_height, _delta)
		if position.y >= min_float_height - float_height_varitaion:
			float_height = max_float_height
		if position.y <= max_float_height + float_height_varitaion:
			float_height = min_float_height
