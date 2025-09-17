extends Control

@export var selectable_areas: Array = [
	Node2D,
	Node2D
]
@export var selecter: Polygon2D
var currently_selected: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Player_1_Left"):
		currently_selected -= 1
	if Input.is_action_just_pressed("Player_1_Right"):
		currently_selected += 1
	currently_selected = clampi(currently_selected, 0, 1)
	selecter.global_position = get_node(selectable_areas[currently_selected]).global_position
	if Input.is_action_just_pressed("Player_1_Settings"):
		queue_free()
