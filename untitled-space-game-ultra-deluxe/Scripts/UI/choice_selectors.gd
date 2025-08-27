extends Control

const POS_INT: int = 45
@export var selector: Sprite2D
@export var pos_no: int = 0
@export var mouse_collider: StaticBody2D
var dir: Vector2
var mouse_active: bool = false
const MOVE_SPEED: int = 15
const START_POS: = Vector2(576, 326)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	get_viewport().warp_mouse(START_POS)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_collider.global_position = lerp(mouse_collider.global_position, get_viewport().get_mouse_position(), delta * MOVE_SPEED)
	
	# Constantly lerping position for smooth movement
	selector.global_position = lerp(selector.global_position, START_POS + Vector2((POS_INT * dir.x),-(POS_INT * dir.y)), delta * MOVE_SPEED)
	
	# If the player cannot move then let the selector move
	if not global.can_player_move:
		#region WASD CONTROLS
		# Get Inputs to move the selector
		dir = Input.get_vector("Player_1_Left", "Player_1_Right", "Player_1_Backwards", "Player_1_Forwards")
		
		# Tells the game what option you are on
		if dir.y > 0:
			pos_no = 0
			mouse_active = false
		elif dir.x > 0:
			pos_no = 1
			mouse_active = false
		elif dir.y < 0:
			pos_no = 2
			mouse_active = false
		elif dir.x < 0:
			pos_no = 3
			mouse_active = false
		elif not mouse_active:
			pos_no = 4
		#endregion



func _on_fight_mouse_area_body_entered(_body: Node2D) -> void:
	pos_no = 0
	mouse_active = true


func _on_resources_mouse_area_body_entered(_body: Node2D) -> void:
	pos_no = 1
	mouse_active = true


func _on_move_mouse_area_body_entered(_body: Node2D) -> void:
	pos_no = 2
	mouse_active = true


func _on_cancel_mouse_area_body_entered(_body: Node2D) -> void:
	pos_no = 3
	mouse_active = true
