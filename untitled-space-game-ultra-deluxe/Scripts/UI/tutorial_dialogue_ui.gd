extends CanvasLayer


@export var textbox: Label
@export var text_increase_timer: Timer
var text_increaser: int = 1
var current_text: int = 0
var current_character: int = 0
# Dialogue
var dia_1: String = "Welcome to your company mandated, state of the art, training simulation!"
var dia_2: String = "To get started, try walking around with WASD."
var dia_3: String = "Nice work!
	Now try looking around for a button."
var dia_4: String = "Awesome work, we will come back to this later.
	For now, Try jumping across that gap with WASD and SPACE."
var dia_5: String = "Collecting resources is the key to your survival and job.
	Try picking up those red objects with E."
var dia_6: String = "Now that the wall has lowered, try using your flashlight on those solid walls by pressing F."
var dia_7: String = "Once again, jump across the gap.
	(PRESS AND HOLD SHIFT TO SPRINT.)"
var dia_8: String = "Now interact with that button to raise the bridges and command that 'Crew Member' to move. (You can do both by pressing E)"
var dia_9: String = "Nice work! The higher ups congratulate you on your new position."
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
	dia_9
]
var can_go_next_character: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.visible_ratio = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	textbox.text = all_dia[current_text]
	if Input.is_action_just_pressed("Player_1_Accept"):
		if textbox.visible_ratio != 1:
			textbox.visible_ratio = 1
		else:
			_next_text()


func _on_timer_timeout() -> void:
	if textbox.visible_ratio != 1:
		if all_dia[current_text][current_character].contains(",") and not can_go_next_character:
			can_go_next_character = true
			text_increase_timer.start(0.15)
		elif all_dia[current_text][current_character].contains(".") and not can_go_next_character:
			can_go_next_character = true
			text_increase_timer.start(0.15)
		elif all_dia[current_text][current_character].contains("!") and not can_go_next_character:
			can_go_next_character = true
			text_increase_timer.start(0.15)
		else:
			textbox.visible_characters += text_increaser
			current_character += 1
			can_go_next_character = false
			text_increase_timer.start(0.05)


func _next_text():
	var max_dia: int = -1
	for i in all_dia:
		max_dia += 1
	if current_text != max_dia:
		textbox.visible_ratio = 0
		current_text += 1
		current_character = 0
		text_increase_timer.start(0.05)
