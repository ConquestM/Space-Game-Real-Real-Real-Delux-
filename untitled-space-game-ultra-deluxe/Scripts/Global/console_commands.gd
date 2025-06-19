extends Node


const TIME_DIVISION: float = 4.0
var time_of_day: float = 0.25
var level_of_fog: float = 0
var current_command: PackedStringArray
var time_frozen: bool = false
var time_speed: float = 10.0
var player_speed: float = 1.0
var player_jump: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _execute_command():
	if current_command[0].contains("time") and current_command[1].contains("set"):
		time_of_day = float(current_command[2]) / TIME_DIVISION
	if current_command[0].contains("time") and current_command[1].contains("speed"):
		time_speed = float(current_command[2])
	if current_command[0].contains("fog") and current_command[1].contains("set"):
		level_of_fog = float(current_command[2])
	if current_command[0].contains("time") and current_command[1].contains("freeze"):
		time_frozen = true
	if current_command[0].contains("time") and current_command[1].contains("unfreeze"):
		time_frozen = false
	if current_command[0].contains("speed") and current_command[1].contains("set"):
		player_speed = float(current_command[2])
	if current_command[0].contains("jump") and current_command[1].contains("set"):
		player_jump = float(current_command[2])
