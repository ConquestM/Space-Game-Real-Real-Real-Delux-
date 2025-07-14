extends CharacterBody2D


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		velocity = Input.get_vector("Player_1_Left", "Player_1_Right", "Player_1_Forwards", "Player_1_Backwards") * 400
	move_and_slide()
