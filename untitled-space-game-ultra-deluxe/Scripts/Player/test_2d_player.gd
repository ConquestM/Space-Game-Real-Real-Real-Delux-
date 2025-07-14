extends Node2D


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("Player_1_Right"):
			print(name)
	if is_multiplayer_authority():
		if Input.is_action_pressed("Player_1_Forwards"):
			position.y -= 5
		if Input.is_action_pressed("Player_1_Backwards"):
			position.y += 5
		if Input.is_action_pressed("Player_1_Left"):
			position.x -= 5
		if Input.is_action_pressed("Player_1_Right"):
			position.x += 5
			print(name)
