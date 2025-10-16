extends Node3D


const PLAYER_POS_INCREASER: int = 1
const BRIDGE_POS: int = 0
const REAL_BODY_VECTOR: Vector3 = Vector3(0, 0, 0)
const GO_AWAY_INCREASER: float = 0.01
const GO_AWAY_COLOR_FLOAT: float = 0.0
var can_move_body: bool = false
var body_real: Node3D
@export var lerp_timer: Timer
@export var wall_timer: Timer
@export var wall_1: AnimatableBody3D
@export var worldenviro: WorldEnvironment
@export var player_scene: PackedScene
@export var bridges: Array
@export var nav_mesh: NavigationRegion3D
@export var go_awayinator: ColorRect
# Multiplayer Stuff
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
# Ending Stuff
var go_away: bool = false
var increaser: float = 0.0
signal tutorial_start


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not global.multiplayer_on:
		var player = player_scene.instantiate()
		add_child(player, true)
		player.position.y += PLAYER_POS_INCREASER
	SignalBus._objective_connect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(increaser)
	if can_move_body and body_real.has_meta("player"):
		body_real.get_node("Collision").disabled = true
		body_real.velocity = REAL_BODY_VECTOR
		body_real.position = lerp(body_real.position, global.last_player_pos, (delta * 2))
	
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
	
	if go_away:
		increaser += GO_AWAY_INCREASER
		go_awayinator.get_parent().show()
		go_awayinator.color = Color(
			GO_AWAY_COLOR_FLOAT, GO_AWAY_COLOR_FLOAT, GO_AWAY_COLOR_FLOAT, increaser
		)
	if increaser >= 1:
		get_tree().change_scene_to_file("res://Scenes/Gameplay Scenes/Non-Planetoid/Ship.tscn")


# Move player back to where they jumped from
func _on_respawn_body_entered(body: Node3D) -> void:
	if body.has_meta("player"):
		global.can_player_move = false
		can_move_body = true
		body_real = body
		lerp_timer.start()


func _on_lerptimer_timeout() -> void:
	if body_real.has_meta("player"):
		global.can_player_move = true
		can_move_body = false
		body_real.get_node("Collision").disabled = false


func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player, true)
	player.position.y += PLAYER_POS_INCREASER


func _on_sim_resource_tree_exited() -> void:
	if global.resources == 3:
		wall_timer.start()


func _on_walltimer_timeout() -> void:
	if wall_1.position.y >= -9:
		wall_1.position.y -= PLAYER_POS_INCREASER
		wall_timer.start()


func _end_tutorial():
	go_away = true


func bridge_button():
	for i in bridges:
		get_node(i).position.y = BRIDGE_POS
	nav_mesh.bake_navigation_mesh()
