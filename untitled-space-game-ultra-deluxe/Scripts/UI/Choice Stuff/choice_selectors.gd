extends Control

const POS_INT: int = 45
const DELTA_MULTIPLIER: int = 15
const POS_NO_ZERO: int = 0
const POS_NO_ONE: int = 1
const POS_NO_TWO: int = 2
const POS_NO_THREE: int = 3
const POS_NO_FOUR: int = 4
@export var selector: MeshInstance2D
var dir: Vector2
var pos_no: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Constantly lerping position for smooth movement
	selector.position = lerp(
		selector.position, Vector2((POS_INT * dir.x),-(POS_INT * dir.y)), delta * DELTA_MULTIPLIER
	)
	
	# If the player cannot move then let the selector move
	if global.can_player_move:
		# Get Inputs to move the selector
		dir = Input.get_vector("Player_1_Left", "Player_1_Right", "Player_1_Backwards", "Player_1_Forwards")
		
		# Tells the game what option you are on
		if dir.y > POS_NO_ZERO:
			pos_no = POS_NO_ZERO
		elif dir.x > POS_NO_ZERO:
			pos_no = POS_NO_ONE
		elif dir.y < POS_NO_ZERO:
			pos_no = POS_NO_TWO
		elif dir.x < POS_NO_ZERO:
			pos_no = POS_NO_THREE
		else:
			pos_no = POS_NO_FOUR
