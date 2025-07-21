extends Node3D


var can_move_body: bool = false
var body_real: Node3D
@export var lerp_timer: Timer
# Multiplayer Stuff
@export var player_scene: PackedScene
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not global.multiplayer_on:
		var player = player_scene.instantiate()
		add_child(player, true)
		player.position.y += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move_body:
		body_real.get_node("Collision").disabled = true
		body_real.velocity = Vector3(0, 0, 0)
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


# Move player back to where they jumped from
func _on_respawn_body_entered(body: Node3D) -> void:
	global.can_player_move = false
	can_move_body = true
	body_real = body
	lerp_timer.start()


func _on_lerptimer_timeout() -> void:
	global.can_player_move = true
	can_move_body = false
	body_real.get_node("Collision").disabled = false


func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player, true)
	player.position.y += 1
