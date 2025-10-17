class_name Player 
extends CharacterBody3D

const CAMERA_ROTATION_DEGREES: int = 80
const MOVE_CAMERA_LOOKING_TARGET_POS: Vector3 = Vector3(0, 0, -3)
const CAMERA_LOOKING_TARGET_POS: Vector3 = Vector3(0, -3, -3)
const EMPTY_STRING: String = " "
const CROUCH_HEIGHT_FLOAT: float = 0.5
const ZERO: int = 0
const JUMP_HEIGHT: int = 2
const UNSTUCK_HEIGHT: int = 50

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
@export var green_flash: AnimationPlayer
@export_group("Script Stuff")
@export var coyote_timer: Timer
@export var pause_menu: PackedScene
@export var game_over: PackedScene

# Player Statistics
var jump_velocity = 4.5
var movement_speed = 4.5
var sensitivity = 0.01
var fov = 80 # Field of view
var normal_stats = [
	4.5, # Movement Speed
	2, # Height
	0.75 # Camera Height 
]
var sprint_stats = [
	6.5, # Movement Speed
	10, # fov Increase
	0.75 # fov Transitioner
]
var crouch_stats = [
	2, # Movement Speed
	1.5, # Height
	0.25 # Camera Height 
]
# Flags
var cursor_mode_bool = true
var can_jump = true
var coyote_timer_on = false
var flashlight_enabled = false
# Nodes
var looking_object = null
var cam_cutscene_point = null


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
	SignalBus.objective_completion.connect(_objective_completion)
	global.player = get_tree().get_first_node_in_group("player")


# Non-Physics Processing
func _process(_delta: float) -> void:
	if global.health <= 0:
		print("death")
		get_tree().change_scene_to_packed(game_over)
	if global.hunger <= 0:
		print("death")
		get_tree().change_scene_to_packed(game_over)
	if global.thirst <= 0:
		print("death")
		get_tree().change_scene_to_packed(game_over)
	if global.loading_screen_active:
		crosshair.hide()
	# Debug Console
	if (
		Input.is_action_just_pressed("Enable_Debug_Console") 
		and is_multiplayer_authority() and false
	):
		if not global.can_player_move:
			ConsoleCommands.current_command = debug_console.text.split(EMPTY_STRING, true)
			ConsoleCommands._execute_command()
		else:
			debug_console.grab_focus()
		global.can_player_move = not global.can_player_move
		debug_console.text = EMPTY_STRING
		debug_console.visible = not debug_console.visible
		debug_console.editable = not debug_console.editable
	
	# Fixes a bug with space view UI
	if global.exitspaceui == true:
		camera_rotator.get_node("Camera3D").current = true
		global.exitspaceui = false
	
	# Unlock Mouse
	if Input.is_action_just_pressed("Player_1_Settings") and is_multiplayer_authority():
		if not global.can_player_move_camera:
			global.can_player_move_camera = true
			global.can_player_move = true
			global.can_player_interact = true
			camera_rotator.get_node("Camera3D").current = true
		else:
			var pause = pause_menu.instantiate()
			cursor_mode_bool = not cursor_mode_bool
			if cursor_mode_bool:
				# Locked Mouse
				DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
				global.can_player_move = true
				pause.queue_free()
			else:
				# Unlocked Mouse
				DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
				add_child(pause)
				global.can_player_move = false
	
	# Flashlight Code
	if Input.is_action_just_pressed("Player_1_Flashlight") and is_multiplayer_authority():
		if global.can_player_move:
			flashlight.visible = not flashlight.visible
	
	# Interaction Code
	if looking.is_colliding():
		looking_object = looking.get_collider()
		if global.can_player_interact:
			if Input.is_action_just_pressed("Player_1_Interact"):
				if looking_object.has_meta("Crewmate"):
					looking_object._spawn_ui()
				else:
					global.collected_object = looking_object
	
	# Sets the camera to a specific nodes position when using the ship computer.
	if global.play_camera_cutscene_1:
		global.play_camera_cutscene_1 = false
		for index in get_tree().current_scene.get_children():
			if index.name == "Camera_Cutscene_Point":
				cam_cutscene_point = index
				_camera_cutscene()
	
	if resourcebars == null: return
	if not global.can_player_move_camera:
		resourcebars.get_node("CanvasLayer").hide()
	else:
		if get_node_or_null("CanvasLayer") == null: return
		resourcebars.get_node("CanvasLayer").show()


func _physics_process(delta: float) -> void:
	# Multiplayer Checks
	if not is_multiplayer_authority():
		camera_rotator.get_node("Camera3D").current = false
	else:
		model.get_node("Visor").hide()
	
	
	if ConsoleCommands.unstuck == true:
		position.y += UNSTUCK_HEIGHT
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
			global.last_player_pos = position + Vector3(ZERO, JUMP_HEIGHT, ZERO)

	# Movement
	if global.can_player_move:
		looking.target_position = MOVE_CAMERA_LOOKING_TARGET_POS
		crosshair.show()
		# Avoid controlling other players, only yourself
		if is_multiplayer_authority():
			var input_dir := Input.get_vector(
				"Player_1_Left", "Player_1_Right", "Player_1_Forwards", "Player_1_Backwards"
			)
			var direction := (
				transform.basis * Vector3(input_dir.x, ZERO, input_dir.y)
			).normalized()
			if direction:
				# Moves positively in x and z because direction is positive
				velocity.x = (direction.x * movement_speed)
				velocity.z = (direction.z * movement_speed)
			else:
				# Moves Negatively in x and z because direction is Negative
				velocity.x = move_toward(velocity.x, ZERO, movement_speed)
				velocity.z = move_toward(velocity.z, ZERO, movement_speed)
			
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
				position.y -= CROUCH_HEIGHT_FLOAT
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
		looking.target_position = CAMERA_LOOKING_TARGET_POS
		crosshair.hide()

	move_and_slide()

# Camera Shtuff
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and global.can_player_move_camera:
		if (
			DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED 
			and is_multiplayer_authority()
		):
			rotate_y(-event.relative.x * sensitivity) # Rotates the x axis reletive to mouse.
			# Rotates the y axis reletive to mouse, and has a cap to stop the player from breaking their neck.
			camera_rotator.rotate_x(-event.relative.y * sensitivity)
			camera_rotator.rotation.x = clamp(
				camera_rotator.rotation.x, deg_to_rad(
					-CAMERA_ROTATION_DEGREES
				), deg_to_rad(
					CAMERA_ROTATION_DEGREES
				)
			)


# Coyote Time Handler
func _on_coyote_timer_timeout() -> void:
	can_jump = false
	coyote_timer_on = false


func _on_window_close_requested() -> void:
	multiplayer_helper.queue_free()


func _camera_cutscene():
	cam_cutscene_point.get_node("Camera3D").current = true


func _objective_completion():
	green_flash.play("flash")
