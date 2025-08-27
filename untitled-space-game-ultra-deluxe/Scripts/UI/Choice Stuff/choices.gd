class_name Choice2D

extends Sprite2D

@export var parent: Control
var scale_float: float = 1
const MOVE_SPEED: int = 15


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var parent_crewmate = get_parent().get_parent().get_parent()
	
	global_scale = lerp(global_scale, Vector2(scale_float, scale_float), delta * MOVE_SPEED)
	
	if parent.pos_no != 4 and self == parent.get_child(parent.pos_no):
		scale_float = 1.15
		if Input.is_action_just_pressed("Player_1_Interact"):
			if name == "Cancel":
				_kill_self()
			if name == "Move":
				parent_crewmate._search_for_move_to()
				_kill_self()
	else:
		scale_float = 0.85
	
	if parent.pos_no != 4 and self == parent.get_child(parent.pos_no):
		for i in get_parent().get_node("Text").get_children():
			if i.name == name:
				i.show()
			else:
				i.hide()
	else:
		for i in get_parent().get_node("Text").get_children():
			if i.name == name:
				i.hide()


func _kill_self():
	var parent_crewmate = get_parent().get_parent().get_parent()
	var ui = get_parent().get_parent()
	
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	global.can_player_move = true
	parent_crewmate._wait_ui()
	ui.queue_free()
