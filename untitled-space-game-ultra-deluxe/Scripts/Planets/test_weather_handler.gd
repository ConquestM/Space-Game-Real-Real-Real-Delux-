extends Node

@export var fog_increase_timer: Timer
@export var planet: Node3D
@export var world: WorldEnvironment
const MIN_FOG_DENS: int = 0
var fog_density: float = 0.0
var can_change_fog: bool = false
var fog_change_rate: float = 0.01


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ConsoleCommands.weather_changed:
		_change_weather(ConsoleCommands.weather)


func _change_weather(weather_type: String):
	ConsoleCommands.weather_changed = false
	if weather_type.contains("fog"):
		if ConsoleCommands.current_command[3].contains("true"):
			world.environment.volumetric_fog_enabled = true
			fog_density = MIN_FOG_DENS
			can_change_fog = true
		elif ConsoleCommands.current_command[3].contains("false"):
			world.environment.volumetric_fog_enabled = false
			fog_density = MIN_FOG_DENS
			can_change_fog = false
		


func _on_fog_increase_timer_timeout() -> void:
	if can_change_fog:
		world.environment.volumetric_fog_density = fog_density
		fog_density += fog_change_rate
		if fog_density >= planet.MAX_FOG_DENSITY:
			can_change_fog = false
