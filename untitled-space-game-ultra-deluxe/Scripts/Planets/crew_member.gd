extends Crewmate


const CREW_UI_SCENE: PackedScene = preload("res://Scenes/UI/crew_ui.tscn")
var id = get_instance_id()


func _process(_delta: float) -> void:
	print(health)
	if global.collected_object == instance_from_id(id) and global.can_player_move:
		var crew_ui = CREW_UI_SCENE.instantiate()
		
		add_child(crew_ui)
		global.can_player_move = false
		
