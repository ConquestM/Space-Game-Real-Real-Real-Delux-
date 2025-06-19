extends Node3D

const DAYNIGHT_INCREASER = 0.01
@export var daynight_cycle_timer: Timer
@export var world_enviroment: WorldEnvironment
var day_or_night = true # True = Day, False = Night
var can_increase_time = true


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	print(world_enviroment.environment.sky.sky_material.sky_energy_multiplier)


func _on_day_night_cycle_timer_timeout() -> void:
	# Set Brightness of sky for DAY / NIGHT effect
	if day_or_night == true: # If day, get darker
		world_enviroment.environment.sky.sky_material.sky_energy_multiplier -= DAYNIGHT_INCREASER # Darken Sky
		world_enviroment.environment.ambient_light_energy -= DAYNIGHT_INCREASER # Decrease Light from Sky
		if world_enviroment.environment.sky.sky_material.sky_energy_multiplier < 0:
			day_or_night = false # Start Night Time
			can_increase_time = false
	
	elif day_or_night == false: # If night, get brighter
		if can_increase_time == true:
			world_enviroment.environment.sky.sky_material.sky_energy_multiplier += DAYNIGHT_INCREASER # Lighten Sky
			world_enviroment.environment.ambient_light_energy += DAYNIGHT_INCREASER # Increase Light from Sky
			if world_enviroment.environment.sky.sky_material.sky_energy_multiplier > 1:
				day_or_night = true # Start day time
		else:
			can_increase_time = true
