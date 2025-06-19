extends CharacterBody3D


@export var model: MeshInstance3D
@export var collision: CollisionShape3D
@export var camera_Rotator: Node3D
@export var coyote_Timer: Timer
@export var flashlight: SpotLight3D
@export var debug_console: TextEdit
var jump_velocity = 4.5
var movement_speed = 5.0
var sensitivity = 0.01
var switchout = false
var cursor_mode = false
var can_jump = true
var coyote_timer_on = false
var fov = 80 # Field of view
var normal_stats = [
	5.0, # Movement Speed
	2, # Height
	0.75 # Camera Height 
]
var sprint_stats = [
	8.0, # Movement Speed
	10, # fov Increase
	0.75 # fov Transitioner
]
var crouch_stats = [
	2.0, # Movement Speed
	1.5, # Height
	0.25 # Camera Height 
]
var flashlight_enabled = false
var in_debug_console = false


func _physics_process(delta: float) -> void:
	# Handle Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		if coyote_timer_on == false:
			coyote_Timer.start()
			coyote_timer_on = true
	else:
		can_jump = true

	# Allows player to jump if coyote time is on or if they are on the ground
	if Input.is_action_just_pressed("Player_1_Jump") and can_jump and not in_debug_console:
		velocity.y = jump_velocity * ConsoleCommands.player_jump
		can_jump = false

	# Movement
	if not in_debug_console:
		var input_dir := Input.get_vector("Player_1_Left", "Player_1_Right", "Player_1_Forwards", "Player_1_Backwards")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			# Moves positively in x and z because direction is positive
			velocity.x = (direction.x * movement_speed)
			velocity.z = (direction.z * movement_speed)
		else:
			# Moves Negatively in x and z because direction is Negative
			velocity.x = move_toward(velocity.x, 0, movement_speed)
			velocity.z = move_toward(velocity.z, 0, movement_speed)
		
		# Sprinting
		if Input.is_action_pressed("Player_1_Sprint"):
			# Set Sprinting stats
			movement_speed = sprint_stats[0] * ConsoleCommands.player_speed
			if camera_Rotator.get_node("Camera3D").fov < fov + sprint_stats[1]:
				camera_Rotator.get_node("Camera3D").fov += sprint_stats[2]
		else:
			# Set Normal Stats if not sprinting
			movement_speed = normal_stats[0] * ConsoleCommands.player_speed
			if camera_Rotator.get_node("Camera3D").fov > fov:
				camera_Rotator.get_node("Camera3D").fov -= sprint_stats[2]
		
		# Crouching
		if Input.is_action_just_pressed("Player_1_Crouch"): 
			# Smoothen camera going down
			position.y -= 0.5
		if Input.is_action_pressed("Player_1_Crouch"):
			# Set Crouch Stats if crouching
			movement_speed = crouch_stats[0] * ConsoleCommands.player_speed
			model.mesh.height = crouch_stats[1]
			collision.shape.height = crouch_stats[1]
			camera_Rotator.position.y = crouch_stats[2]
		elif not Input.is_action_pressed("Player_1_Sprint"):
			# Set Normal Stats if not sprinting
			movement_speed = normal_stats[0] * ConsoleCommands.player_speed
			model.mesh.height = normal_stats[1]
			collision.shape.height = normal_stats[1]
			camera_Rotator.position.y = normal_stats[2]

		move_and_slide()


# Non-Physics Processing
func _process(_delta: float) -> void:
	# Debug Console
	if Input.is_action_just_pressed("Enable_Debug_Console"):
		if in_debug_console:
			ConsoleCommands.current_command = debug_console.text.split(" ", true)
			ConsoleCommands._execute_command()
		else:
			debug_console.grab_focus()
		in_debug_console = not in_debug_console
		debug_console.text = ""
		debug_console.visible = not debug_console.visible
		debug_console.editable = not debug_console.editable
	
	# Unlock Mouse
	if Input.is_action_just_pressed("Player_1_Settings"):
		cursor_mode = not cursor_mode
		if cursor_mode:
			# Locked Mouse
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
		else:
			# Unlocked Mouse
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	
	# flashlight Code
	if Input.is_action_just_pressed("Player_1_Flashlight"):
		if not in_debug_console:
			flashlight.visible = not flashlight.visible


# Camera Shit
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * sensitivity)
			if switchout == false:
				camera_Rotator.get_node("Camera3D").rotate_x(-event.relative.y * sensitivity)
				camera_Rotator.get_node("Camera3D").rotation.x = clamp(camera_Rotator.get_node("Camera3D").rotation.x, deg_to_rad(-80), deg_to_rad(80))
			if switchout == true:
				camera_Rotator.rotate_x(-event.relative.y * sensitivity)
				camera_Rotator.rotation.x = clamp(camera_Rotator.rotation.x, deg_to_rad(-60), deg_to_rad(60))


# Coyote Time Handler
func _on_coyote_Timer_timeout() -> void:
	can_jump = false
	coyote_timer_on = false
