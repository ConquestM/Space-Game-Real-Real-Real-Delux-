extends Control

const POS_INT: int = 45
@export var selector: MeshInstance2D
@export var pos_no: int = 0
var dir: Vector2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Constantly lerping position for smooth movement
	selector.position = lerp(selector.position, Vector2((POS_INT * dir.x),-(POS_INT * dir.y)), delta * 15)
	
	# If the player cannot move then let the selector move
	if global.can_player_move:
		# Get Inputs to move the selector
		dir = Input.get_vector("Player_1_Left", "Player_1_Right", "Player_1_Backwards", "Player_1_Forwards")
		
		# Tells the game what option you are on
		if dir.y > 0:
			pos_no = 0
		elif dir.x > 0:
			pos_no = 1
		elif dir.y < 0:
			pos_no = 2
		elif dir.x < 0:
			pos_no = 3
		else:
			pos_no = 4
