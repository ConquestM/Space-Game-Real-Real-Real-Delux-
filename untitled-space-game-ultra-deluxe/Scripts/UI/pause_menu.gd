extends Control

@export var selector: Line2D
@export var buttons: Array
var current_button: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	current_button = clamp(current_button, 0, 2)
	var button = get_node(buttons[current_button])
	
	selector.position.x = button.position.x + (button.position.x + button.size.x + 50)
	selector.position.y = button.position.y
	
	if Input.is_action_just_pressed("Player_1_Forwards") or Input.is_action_just_pressed("Player_1_Backwards"): 
		var dir = Input.get_axis("Player_1_Forwards", "Player_1_Backwards")
		
		current_button += int(dir)
		dir = 0
	if Input.is_action_just_pressed("Player_1_Settings"):
		queue_free()
	if Input.is_action_just_pressed("Player_1_Accept"):
		if current_button == 0:
			_on_button_1_pressed()
		elif current_button == 1:
			_on_button_2_pressed()
		elif current_button == 2:
			_on_button_3_pressed()


func _on_button_1_pressed() -> void:
	if current_button != 0:
		current_button = 0
	else:
		queue_free()


func _on_button_2_pressed() -> void:
	if current_button != 1:
		current_button = 1
	else:
		print("name")


func _on_button_3_pressed() -> void:
	if current_button != 2:
		current_button = 2
	else:
		get_tree().change_scene_to_file("res://Scenes/UI/nondiegetic_computer_menu.tscn")
