extends StaticBody3D


const CREW_UI_SCENE: String = "res://Scenes/UI/crew_ui.tscn"
var id = get_instance_id()


func _enter_tree() -> void:
	ResourceLoader.load_threaded_request(CREW_UI_SCENE)


func _process(_delta: float) -> void:
	if global.collected_object == instance_from_id(id):
		ResourceLoader.load_threaded_get(CREW_UI_SCENE)
