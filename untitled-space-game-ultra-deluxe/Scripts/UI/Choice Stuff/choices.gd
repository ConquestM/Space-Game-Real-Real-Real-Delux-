extends Sprite2D

@export var parent: Control
var scale_float: float = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_scale = lerp(global_scale, Vector2(scale_float, scale_float), delta * 15)
	
	if parent.pos_no != 4 and self == parent.get_child(parent.pos_no):
		scale_float = 1.15
		if Input.is_action_just_pressed("Player_1_Interact"):
			if name == "Cancel":
				get_parent().get_parent().queue_free()
				global.can_player_move = true
	else:
		scale_float = 0.85
