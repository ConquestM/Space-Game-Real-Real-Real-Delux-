extends StaticBody3D

@export var resource: Node
var id = get_instance_id()
var float_height: float = 2.6


func _process(_delta: float) -> void:
	if global.collected_object == instance_from_id(id):
		global.resources += 1
		global.collected_object = null
		print("button")
