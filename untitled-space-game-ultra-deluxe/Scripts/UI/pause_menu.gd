extends Control

const CURRENT_BUTTON_CLAMP_MIN: int = 0
const CURRENT_BUTTON_CLAMP_MAX: int = CURRENT_BUTTON_ARRAY[2]
const BUTTON_SIZE_INCREASER: int = 50
const CURRENT_BUTTON_ARRAY: Array = [
	0,
	1,
	2,
	3,
	4,
	5,
	6
]
const NO_DIR: int = 0

@export var selector: Line2D
@export var buttons: Array

var current_button: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	current_button = clamp(current_button, CURRENT_BUTTON_CLAMP_MIN, CURRENT_BUTTON_CLAMP_MAX)
	var button = get_node(buttons[current_button])
	
	selector.position.x = button.position.x + (
		button.position.x + button.size.x + BUTTON_SIZE_INCREASER
	)
	selector.position.y = button.position.y
	
	if (
		Input.is_action_just_pressed("Player_1_Forwards") 
		or Input.is_action_just_pressed("Player_1_Backwards")
	):
		var dir = Input.get_axis("Player_1_Forwards", "Player_1_Backwards")
		
		current_button += int(dir)
		dir = NO_DIR
	if Input.is_action_just_pressed("Player_1_Settings"):
		queue_free()
	if Input.is_action_just_pressed("Player_1_Accept"):
		if current_button == CURRENT_BUTTON_ARRAY[0]:
			_on_button_1_pressed()
		elif current_button == CURRENT_BUTTON_ARRAY[1]:
			_on_button_2_pressed()
		elif current_button == CURRENT_BUTTON_ARRAY[2]:
			_on_button_3_pressed()


func _on_button_1_pressed() -> void:
	if current_button != CURRENT_BUTTON_ARRAY[0]:
		current_button = CURRENT_BUTTON_ARRAY[0]
	else:
		queue_free()


func _on_button_2_pressed() -> void:
	if current_button != CURRENT_BUTTON_ARRAY[1]:
		current_button = CURRENT_BUTTON_ARRAY[1]
	else:
		print("name")


func _on_button_3_pressed() -> void:
	if current_button != CURRENT_BUTTON_ARRAY[2]:
		current_button = CURRENT_BUTTON_ARRAY[2]
	else:
		get_tree().change_scene_to_file("res://Scenes/UI/nondiegetic_computer_menu.tscn")
