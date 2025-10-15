extends Node


const TIME_DIVISION: float = 4.0
const FIRST_COMMAND: int = 0
const SECOND_COMMAND: int = 1
const THIRD_COMMAND: int = 2
const FOURTH_COMMAND: int = 3
var time_of_day: float = 0.25
var level_of_fog: float = 0
var current_command: PackedStringArray
var time_frozen: bool = false
var time_speed: float = 1
var player_speed: float = 1.0
var player_jump: float = 1.0
var weather: String = "Overcast"
var weather_changed: bool = false
var unstuck: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _execute_command():
	if current_command[FIRST_COMMAND].contains("time") and current_command[SECOND_COMMAND].contains("set"):
		time_of_day = float(current_command[THIRD_COMMAND]) / TIME_DIVISION
	if current_command[FIRST_COMMAND].contains("time") and current_command[SECOND_COMMAND].contains("speed"):
		time_speed = float(current_command[THIRD_COMMAND])
	if current_command[FIRST_COMMAND].contains("fog") and current_command[SECOND_COMMAND].contains("set"):
		level_of_fog = float(current_command[THIRD_COMMAND])
	if current_command[FIRST_COMMAND].contains("time") and current_command[SECOND_COMMAND].contains("freeze"):
		time_frozen = true
	if current_command[FIRST_COMMAND].contains("time") and current_command[SECOND_COMMAND].contains("unfreeze"):
		time_frozen = false
	if current_command[FIRST_COMMAND].contains("speed") and current_command[SECOND_COMMAND].contains("set"):
		player_speed = float(current_command[THIRD_COMMAND])
	if current_command[FIRST_COMMAND].contains("jump") and current_command[SECOND_COMMAND].contains("set"):
		player_jump = float(current_command[THIRD_COMMAND])
	if current_command[FIRST_COMMAND].contains("weather") and current_command[SECOND_COMMAND].contains("set"):
		weather = current_command[THIRD_COMMAND]
		weather_changed = true
	if current_command[FIRST_COMMAND].contains("game") and current_command[SECOND_COMMAND].contains("host"):
		Online.hosting = true
	if current_command[FIRST_COMMAND].contains("game") and current_command[SECOND_COMMAND].contains("join"):
		Online.joining = true
	if current_command[FIRST_COMMAND].contains("unstuck"):
		unstuck = true
