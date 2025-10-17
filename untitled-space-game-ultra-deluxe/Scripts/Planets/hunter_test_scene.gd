extends Node3D


const MAX_FOG_DENSITY: float = 1
const DAYNIGHT_INCREASER: float = 0.005
const FOG_INCREASER: float = 0.02
const SPAWN_Y_POS: float = 28.5
const PLAYER_POS_INCREASER: int = 1
const SAFTEY: int = 3
@export var daynight_cycle_timer: Timer
@export var world_enviroment: WorldEnvironment
@export var player_scene: PackedScene
@export var terrain: Terrain3D
@export var win: Control
@export var trees: Node
@export var win_timer: Timer
var spawn_rate : int = 0
var enemy_spawn: int = 0
var enemy: Node = null
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var won: bool = false
var world_enviroment_e
var spawn_pos_array: Array = [
	Vector3(0, 28.5, 0)
]
var enemy_list: Array = []
# Sun Stuff
@export var the_sun: DirectionalLight3D
var sun_lerp: float = 270.0
# Time Stuff
var day_or_night: bool = true # True = Day, False = Night
var can_increase_time: bool = true
# Multiplayer Stuff
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()



func _ready() -> void:
	global.health = 100
	global.hunger = 100
	global.thirst = 100
	global.resources = 0
	if not global.multiplayer_on:
		var player = player_scene.instantiate()
		add_child(player, true)
		player.position = $Stuff/Marker3D.position
		world_enviroment_e = world_enviroment.environment
	for i in trees.get_children():
		spawn_pos_array.append(i.position)
	_spawnher()
	global.can_player_interact = true


func _process(delta: float) -> void:
	if global.resources == 15 and won == false:
		win.show()
		won = true
		win_timer.start()
		get_tree().paused = true
	if global.debug_mode:
		print("Fog:", ConsoleCommands.level_of_fog, " Time:", ConsoleCommands.time_of_day)
	# Set world to their variables
	world_enviroment_e.sky.sky_material.sky_energy_multiplier = ConsoleCommands.time_of_day
	world_enviroment_e.ambient_light_energy = ConsoleCommands.time_of_day
	world_enviroment_e.fog_density = ConsoleCommands.level_of_fog
	world_enviroment_e.fog_sky_affect = ConsoleCommands.level_of_fog
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
	print(ConsoleCommands.time_of_day)
	if ConsoleCommands.time_of_day <= 0.15:
		world_enviroment_e.sky.sky_material.sky_top_color = Color(0, 0, 0)
		world_enviroment_e.sky.sky_material.sky_horizon_color = Color(1, 0.5, 0)
	else:
		world_enviroment_e.sky.sky_material.sky_top_color = Color(0.355, 0.61, 1)
		world_enviroment_e.sky.sky_material.sky_horizon_color = Color(0.19, 0.835, 0.981)
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
	player.position.y += PLAYER_POS_INCREASER


func _spawnher():
	var her = preload("res://Scenes/Planet/Resource.tscn").instantiate()
	var max_choice = (spawn_pos_array.size() - SAFTEY)
	
	add_child(her)
	
	her.position.y = SPAWN_Y_POS
	her.position.x = spawn_pos_array[randi_range(0, max_choice)].x
	her.position.z = spawn_pos_array[randi_range(0, max_choice)].z
	her.max_float_height = SPAWN_Y_POS
	her.min_float_height = SPAWN_Y_POS
	her.float_height = SPAWN_Y_POS


func _spawn_enemy():
	enemy_spawn = rng.randi_range(1, 3)
	print(enemy_spawn)
	enemy_list.append(enemy_spawn)
	print(enemy_list)
	for monster in enemy_list:
		if monster == 1:
			enemy = preload("res://Scenes/Enemies/RunnerEnemy.tscn").instantiate()
		elif monster == 2:
			enemy = preload("res://Scenes/Enemies/LeaperEnemy.tscn").instantiate()
		elif monster == 3:
			enemy = preload("res://Scenes/Enemies/HopperEnemy.tscn").instantiate()
		spawn_rate = rng.randi_range(1, 10)
		if spawn_rate == 10:
			var max_choice = (spawn_pos_array.size() - SAFTEY)
			add_child(enemy)
			enemy.position.y = SPAWN_Y_POS
			enemy.position.x = spawn_pos_array[randi_range(0, max_choice)].x
			enemy.position.z = spawn_pos_array[randi_range(0, max_choice)].z


func _on_spawn_timer_timeout():
	_spawn_enemy()


func _on_win_timer_timeout():
	win.hide()
	get_tree().paused = false
