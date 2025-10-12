extends StaticBody3D

@export var resource: Node
var id = get_instance_id()
var float_height: float = 2.6


func _process(_delta: float) -> void:
	if global.collected_object == instance_from_id(id):
		global.resources += 1
		global.collected_object = null
		queue_free()
		get_parent()._spawnher()
	if has_meta("spin"):
		rotation_degrees.y += 1
		position.y = lerp(position.y, float_height, _delta)
		if position.y >= 2.2:
			float_height = 1.75
		if position.y <= 1.8:
			float_height = 2.25
