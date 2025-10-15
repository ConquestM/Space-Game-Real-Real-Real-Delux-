extends StaticBody3D

@export var resource: Node
const MAX_FLOAT_HEIGHT: int = 1.75
const MIN_FLOAT_HEIGHT: int = 2.25
const ROTATE_AMOUNT: int = 1
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
		if position.y >= 2.2:
			float_height = MAX_FLOAT_HEIGHT
		if position.y <= 1.8:
			float_height = MIN_FLOAT_HEIGHT
