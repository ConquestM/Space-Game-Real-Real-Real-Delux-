extends Node3D

@export var resource: Node
var float_height: float = 2.6


func _process(_delta: float) -> void:
	if get_node_or_null("@StaticBody3D@22304") == null: return
	var id = get_node("@StaticBody3D@22304").get_instance_id()
	
	if global.collected_object == instance_from_id(id):
		global.collected_object = null
		global.play_camera_cutscene_1 = true
		global.can_player_move = false
		global.can_player_move_camera = false
		#get_tree().change_scene_to_file("res://Scenes/UI/nondiegetic_computer_menu.tscn")
