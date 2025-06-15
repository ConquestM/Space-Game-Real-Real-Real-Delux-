extends CharacterBody3D


var Jump_Velocity = 4.5
var Movement_Speed = 5.0
var Sensitivity = 0.01
var Switchout = false
var Cursor_Mode = false
var Can_Jump = true
var Coyote_Timer_On = false
var Fov = 80


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Coyote_Timer_On == false:
			$CoyoteTimer.start()
			Coyote_Timer_On = true
	else:
		Can_Jump = true

	# Handle jump.
	if Input.is_action_just_pressed("Player_1_Jump") and Can_Jump:
		velocity.y = Jump_Velocity
		Can_Jump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Player_1_Left", "Player_1_Right", "Player_1_Forwards", "Player_1_Backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * Movement_Speed
		velocity.z = direction.z * Movement_Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Movement_Speed)
		velocity.z = move_toward(velocity.z, 0, Movement_Speed)
	
	if Input.is_action_pressed("Player_1_Sprint"):
		Movement_Speed = 8
		if $RotationHelper/Camera3D.fov < Fov + 10:
			$RotationHelper/Camera3D.fov += 0.75
	else:
		Movement_Speed = 5
		if $RotationHelper/Camera3D.fov > Fov:
			$RotationHelper/Camera3D.fov -= 0.75

	move_and_slide()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Player_1_Settings"):
		Cursor_Mode = not Cursor_Mode
		if Cursor_Mode:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
		else:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * Sensitivity)
			if Switchout == false:
				$RotationHelper/Camera3D.rotate_x(-event.relative.y * Sensitivity)
				$RotationHelper/Camera3D.rotation.x = clamp($RotationHelper/Camera3D.rotation.x, deg_to_rad(-80), deg_to_rad(80))
			if Switchout == true:
				$RotationHelper.rotate_x(-event.relative.y * Sensitivity)
				$RotationHelper.rotation.x = clamp($RotationHelper.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func _on_coyote_timer_timeout() -> void:
	Can_Jump = false
	Coyote_Timer_On = false
