class_name Player extends CharacterBody3D


@export_group("Player Body Stuff")
@export var looking: RayCast3D
@export var multiplayer_helper: Label
@export var model: MeshInstance3D
@export var collision: CollisionShape3D
@export var camera_rotator: Node3D
@export var flashlight: SpotLight3D
@export_group("Player UI Stuff")
@export var crosshair: Sprite2D
@export var resourcebars: Control
@export var debug_console: TextEdit
@export_group("Script Stuff")
@export var coyote_timer: Timer
@export var pause_menu: PackedScene
# Player Statistics
var jump_velocity = 4.5
var movement_speed = 5.0
var sensitivity = 0.01
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
# Flags
var cursor_mode = true
var can_jump = true
var coyote_timer_on = false
var flashlight_enabled = false
# Nodes
var looking_object = null


func _enter_tree() -> void:
	# Multiplayer stuff, basically if not in multiplayer, only spawn one player and not anything multiplayer related.
	set_multiplayer_authority(name.to_int())
	if global.multiplayer_on:
		multiplayer_helper.get_parent().show()
		multiplayer_helper.text = "YOUR IP ADDRESS IS:
			" + Online.hostip
		multiplayer_helper.get_child(0).text = "THE PORT IS:
			" + str(Online.port)
	else:
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
		multiplayer_helper.queue_free()
	# Kill the resources in the tutorial
	if get_tree().current_scene.name == "Tutorial":
		resourcebars.queue_free()
	


func _physics_process(delta: float) -> void:
	# Multiplayer Checks
	if not is_multiplayer_authority():
		camera_rotator.get_node("Camera3D").current = false
	else:
		model.get_node("Visor").hide()
	
	
	if ConsoleCommands.unstuck == true:
		position.y += 50
		ConsoleCommands.unstuck = false
	
	# Handle Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		if coyote_timer_on == false:
			coyote_timer.start()
			coyote_timer_on = true
	else:
		can_jump = true

	# Allows player to jump if coyote time is on or if they are on the ground
	if Input.is_action_just_pressed("Player_1_Jump"):
		if can_jump and is_multiplayer_authority() and global.can_player_move:
			velocity.y = jump_velocity * ConsoleCommands.player_jump
			can_jump = false
			global.last_player_pos = position + Vector3(0, 2, 0)

	# Movement
	if global.can_player_move:
		looking.target_position = Vector3(0, 0, -3)
		crosshair.show()
		# Avoid controlling other players, only yourself
		if is_multiplayer_authority():
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
				if camera_rotator.get_node("Camera3D").fov < fov + sprint_stats[1]:
					camera_rotator.get_node("Camera3D").fov += sprint_stats[2]
			else:
				# Set Normal Stats if not sprinting
				movement_speed = normal_stats[0] * ConsoleCommands.player_speed
				if camera_rotator.get_node("Camera3D").fov > fov:
					camera_rotator.get_node("Camera3D").fov -= sprint_stats[2]
			
			# Crouching
			if Input.is_action_just_pressed("Player_1_Crouch"): 
				# Smoothen camera going down
				position.y -= 0.5
			if Input.is_action_pressed("Player_1_Crouch"):
				# Set Crouch Stats if crouching
				movement_speed = crouch_stats[0] * ConsoleCommands.player_speed
				model.mesh.height = crouch_stats[1]
				collision.shape.height = crouch_stats[1]
				camera_rotator.position.y = crouch_stats[2]
			elif not Input.is_action_pressed("Player_1_Sprint"):
				# Set Normal Stats if not sprinting
				movement_speed = normal_stats[0] * ConsoleCommands.player_speed
				model.mesh.height = normal_stats[1]
				collision.shape.height = normal_stats[1]
				camera_rotator.position.y = normal_stats[2]
	else:
		looking.target_position = Vector3(0, -3, -3)
		crosshair.hide()

	move_and_slide()


# Non-Physics Processing
func _process(_delta: float) -> void:
	# Debug Console
	if Input.is_action_just_pressed("Enable_Debug_Console") and is_multiplayer_authority():
		if not global.can_player_move:
			ConsoleCommands.current_command = debug_console.text.split(" ", true)
			ConsoleCommands._execute_command()
		else:
			debug_console.grab_focus()
		global.can_player_move = not global.can_player_move
		debug_console.text = ""
		debug_console.visible = not debug_console.visible
		debug_console.editable = not debug_console.editable
	
	# Unlock Mouse
	if Input.is_action_just_pressed("Player_1_Settings") and is_multiplayer_authority():
		var pause = pause_menu.instantiate()
		cursor_mode = not cursor_mode
		if cursor_mode:
			# Locked Mouse
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
			global.can_player_move = true
		else:
			# Unlocked Mouse
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
			add_child(pause)
			global.can_player_move = false
	
	# flashlight Code
	if Input.is_action_just_pressed("Player_1_Flashlight") and is_multiplayer_authority():
		if global.can_player_move:
			flashlight.visible = not flashlight.visible
	
	if looking.is_colliding():
		looking_object = looking.get_collider()
		if Input.is_action_just_pressed("Player_1_Interact"):
			global.collected_object = looking_object


# Camera Shtuff
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED and is_multiplayer_authority():
			rotate_y(-event.relative.x * sensitivity) # Rotates the x axis reletive to mouse.
			# Rotates the y axis reletive to mouse, and has a cap to stop the player from breaking their neck.
			camera_rotator.rotate_x(-event.relative.y * sensitivity)
			camera_rotator.rotation.x = clamp(
				camera_rotator.rotation.x, deg_to_rad(-80), deg_to_rad(80)
			)


# Coyote Time Handler
func _on_coyote_timer_timeout() -> void:
	can_jump = false
	coyote_timer_on = false


func _on_window_close_requested() -> void:
	multiplayer_helper.queue_free()
