extends StaticBody3D

@export var resource: Node
var id = get_instance_id()

func _process(_delta: float) -> void:
	if global.collected_object == instance_from_id(id):
		global.resources += 1
		global.collected_object = null
		queue_free()
