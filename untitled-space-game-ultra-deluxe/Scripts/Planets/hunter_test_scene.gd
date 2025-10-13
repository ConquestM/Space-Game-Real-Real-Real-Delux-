extends Node3D


const MAX_FOG_DENSITY: float = 1
const DAYNIGHT_INCREASER: float = 0.005
const FOG_INCREASER: float = 0.02
@export var daynight_cycle_timer: Timer
@export var world_enviroment: WorldEnvironment
@export var player_scene: PackedScene
@export var terrain: Terrain3D
@export var win: Control
# Sun Stuff
@export var the_sun: DirectionalLight3D
var sun_lerp: float = 270.0
# Time Stuff
var day_or_night: bool = true # True = Day, False = Night
var can_increase_time: bool = true
# Multiplayer Stuff
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()



func _ready() -> void:
	if not global.multiplayer_on:
		var player = player_scene.instantiate()
		add_child(player, true)
		player.position = $Stuff/Marker3D.position


func _process(delta: float) -> void:
	if global.resources == 10:
		win.show()
	if global.debug_mode:
		print("Fog:", ConsoleCommands.level_of_fog, " Time:", ConsoleCommands.time_of_day)
	# Set world to their variables
	world_enviroment.environment.sky.sky_material.sky_energy_multiplier = ConsoleCommands.time_of_day
	world_enviroment.environment.ambient_light_energy = ConsoleCommands.time_of_day
	world_enviroment.environment.fog_density = ConsoleCommands.level_of_fog
	world_enviroment.environment.fog_sky_affect = ConsoleCommands.level_of_fog
	daynight_cycle_timer.wait_time = ConsoleCommands.time_speed
	
	# Control the sun
	the_sun.rotation_degrees.x = lerp(the_sun.rotation_degrees.x, sun_lerp, delta)
	
	# Host a game via inputed port
	if Online.hosting:
		Online.hosting = false
		peer.create_server(Online.port)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_add_player)
		_add_player()
	# Join a game via an ip address and port
	if Online.joining:
		Online.joining = false
		peer.create_client(Online.inputedip, Online.port)
		multiplayer.multiplayer_peer = peer


func _on_day_night_cycle_timer_timeout() -> void:
	sun_lerp += 3.6
	if ConsoleCommands.time_of_day <= 0.15:
		world_enviroment.environment.sky.sky_material.sky_top_color = Color(0, 0, 0)
		world_enviroment.environment.sky.sky_material.sky_horizon_color = Color(1, 0.5, 0)
	else:
		world_enviroment.environment.sky.sky_material.sky_top_color = Color(0.355, 0.61, 1)
		world_enviroment.environment.sky.sky_material.sky_horizon_color = Color(0.19, 0.835, 0.981)
	if ConsoleCommands.time_frozen == false:
		# Set Brightness of sky for DAY / NIGHT effect
		if day_or_night == true: # If day, get darker
			ConsoleCommands.time_of_day -= DAYNIGHT_INCREASER # Darken Sky and decrease light
			ConsoleCommands.level_of_fog += FOG_INCREASER
			
			if ConsoleCommands.time_of_day < 0:
				day_or_night = false # Start Night Time
				can_increase_time = false
		
		elif day_or_night == false: # If night, get brighter
			if can_increase_time == true:
				ConsoleCommands.time_of_day += DAYNIGHT_INCREASER # Lighten Sky and increase light
				ConsoleCommands.level_of_fog -= FOG_INCREASER
				
				if ConsoleCommands.time_of_day > 0.25:
					day_or_night = true # Start day time
			else:
				can_increase_time = true


func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player, true)
	player.position.y += 1


func _spawnher():
	var her = preload("res://Scenes/Planet/Resource.tscn").instantiate()
	
	add_child(her)
	
	her.position.y = 30
	her.position.x = randi_range(-50, 50)
	her.position.z = randi_range(-50, 50)
