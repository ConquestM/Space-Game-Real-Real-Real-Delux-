extends CanvasLayer

signal objective_flag
# How much the text should increase by.
const START_TIMES_ARRAY: Array = [
	0.15,
	0.05
]
const OTHER_CONST_ARRAY: Array = [
	0,
	1
]
const TEXT_INCREASER: int = 1
@export var textbox: Label
@export var text_increase_timer: Timer
@export var next_dia_timer: Timer
@export var check_1: Area3D
@export var check_2: Area3D
@export var check_3: Area3D
@export var check_4: Area3D
# Current Dialogue
var current_text: int = OTHER_CONST_ARRAY[0]
# Current Character (Letter) of current Dialogue
var current_character: int = OTHER_CONST_ARRAY[0]
# Dialogue strings
var dia_1: String = "Welcome to your company mandated, state of the art, training simulation!"
var dia_2: String = "To get started, try walking around with WASD."
var dia_3: String = "Nice work!
	Now try looking around for a button."
var dia_4: String = "Awesome work, we will come back to this later.
	For now, Try jumping across that gap with WASD and SPACE."
var dia_5: String = "Collecting resources is the key to your survival and job.
	Try picking up those red objects with (E)."
var dia_6: String = "Now that the wall has lowered, try using your flashlight on those solid walls by pressing F."
var dia_7: String = "Once again, jump across the gap.
	(PRESS AND HOLD SHIFT TO SPRINT.)"
var dia_8: String = "Now interact (E) with that button to raise the bridges."
var dia_9: String = "Finally, Command that Crew Member to move, and they'll press the first button we saw."
var dia_10: String = "Nice work! The higher ups congratulate you on your new position."
# Array to handle all the dialogue
var all_dia: Array = [
	dia_1,
	dia_2,
	dia_3,
	dia_4,
	dia_5,
	dia_6,
	dia_7,
	dia_8,
	dia_9,
	dia_10
]
# This is a flag used to check whether the current character is a , or . or ! to add realism to the text.
var can_go_next_character: bool = false
# Dialogue Progress Flags (Checks), each one corrisponds to the dialogue of it's number + OTHER_CONST_ARRAY[1]. (so req_0 is for dia_1 and so on.)
var req_0: bool = true
var req_1: bool = false
var req_2: bool = false
var req_3: bool = false
var req_4: bool = false
var req_5: bool = false
var req_6: bool = false
var req_7: bool = false
var req_8: bool = false
var req_9: bool = false
# An array to grab all the flags from
var req_array: Array = [
	req_0,
	req_1,
	req_2,
	req_3,
	req_4,
	req_5,
	req_6,
	req_7,
	req_8,
	req_9
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.visible_ratio = OTHER_CONST_ARRAY[0]
	global.can_player_move = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	textbox.text = all_dia[current_text]
	if Input.is_action_just_pressed("Player_1_Accept"):
		if textbox.visible_ratio != OTHER_CONST_ARRAY[1]:
			textbox.visible_ratio = OTHER_CONST_ARRAY[1]
		else:
			_next_text()
	
	_check_reqs()


func _on_timer_timeout() -> void:
	if textbox.visible_ratio != OTHER_CONST_ARRAY[1]:
		# Adds delays when certain characters are detected
		if all_dia[current_text][current_character].contains(",") and not can_go_next_character:
			can_go_next_character = true
			text_increase_timer.start(START_TIMES_ARRAY[0])
		elif all_dia[current_text][current_character].contains(".") and not can_go_next_character:
			can_go_next_character = true
			text_increase_timer.start(START_TIMES_ARRAY[0])
		elif all_dia[current_text][current_character].contains("!") and not can_go_next_character:
			can_go_next_character = true
			text_increase_timer.start(START_TIMES_ARRAY[0])
		else:
			# Increases the visible letters / characters to give an effect of someone writing the text.
			textbox.visible_characters += TEXT_INCREASER
			current_character += OTHER_CONST_ARRAY[1]
			can_go_next_character = false
			text_increase_timer.start(START_TIMES_ARRAY[1])
	else:
		if req_array[current_text]:
			next_dia_timer.start(1)
		else:
			text_increase_timer.start(START_TIMES_ARRAY[1])


func _next_text():
	# Lets the code know how many lines of dialogue there are, then stores that
	var max_dia: int = - OTHER_CONST_ARRAY[1]
	for i in all_dia:
		max_dia += OTHER_CONST_ARRAY[1]
	print(current_text, " ", max_dia)
	# Check to see if the current dialogue is not the final one, if not then it should reset the text and change to the next one.
	if current_text != max_dia:
		textbox.visible_ratio = OTHER_CONST_ARRAY[0]
		current_text += OTHER_CONST_ARRAY[1]
		current_character = OTHER_CONST_ARRAY[0]
		text_increase_timer.start(START_TIMES_ARRAY[1])


func _on_next_dia_timer_timeout() -> void:
	_next_text()
	# Lets the player move after the first dialogue
	if current_text == OTHER_CONST_ARRAY[1]:
		global.can_player_move = true


# Function used to check to see if certain flags should be set to true
func _check_reqs():
	# This checks to see if the player has moved, if so then flag OTHER_CONST_ARRAY[1] is set to true and it stops checking
	if not req_1 and global.can_player_move:
		if (
		Input.is_action_just_pressed("Player_1_Forwards")
		or Input.is_action_just_pressed("Player_1_Backwards")
		or Input.is_action_just_pressed("Player_1_Left")
		or Input.is_action_just_pressed("Player_1_Right")
		):
			req_array[1] = true


# Areas that sets flags to true
func _on_dia_3_body_entered(body: Node3D) -> void:
	if body.has_meta("player"):
		req_array[2] = true
		objective_flag.emit()
		check_1.queue_free()


func _on_dia_4_body_entered(body: Node3D) -> void:
	if body.has_meta("player"):
		req_array[3] = true
		objective_flag.emit()
		check_2.queue_free()


func _on_sim_resource_1_tree_exited() -> void:
	if global.resources == 3:
		req_array[4] = true
		objective_flag.emit()


func _on_dia_5_body_entered(body: Node3D) -> void:
	if body.has_meta("player"):
		req_array[5] = true
		objective_flag.emit()
		check_3.queue_free()


func _on_dia_6_body_entered(body: Node3D) -> void:
	if body.has_meta("player"):
		req_array[6] = true
		objective_flag.emit()
		check_4.queue_free()
