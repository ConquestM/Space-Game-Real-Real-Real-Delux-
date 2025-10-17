extends Node3D

@export var resource: Node
@export var hitbox: NodePath

var float_height: float = 2.6


func _process(_delta: float) -> void:
	# Checks if the object has been interacted with by checking the most recently interacted object
	var id = get_child(1).get_instance_id()
	if global.collected_object == instance_from_id(id):
		global.collected_object = null
		global.play_camera_cutscene_1 = true
		global.can_player_move = false
		global.can_player_move_camera = false
		# Loads the space view UI and lets the player control it while stopping them controlling themself.
		var scene = load("res://Scenes/UI/space_view.tscn")
		add_child(scene.instantiate())
