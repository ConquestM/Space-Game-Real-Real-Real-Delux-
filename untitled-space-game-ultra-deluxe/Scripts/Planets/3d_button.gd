extends StaticBody3D

@export var resource: Node
var id = get_instance_id()
var float_height: float = 2.6


func _process(_delta: float) -> void:
	if global.collected_object == instance_from_id(id):
		global.collected_object = null
		#if name == "Button_Bridge":
		get_tree().current_scene.bridge_button()


func _on_button_area_body_entered(body: Node3D) -> void:
	if body is Crewmate:
		body._run_after_navi("Tutorial_Button")
		body.moving = false
