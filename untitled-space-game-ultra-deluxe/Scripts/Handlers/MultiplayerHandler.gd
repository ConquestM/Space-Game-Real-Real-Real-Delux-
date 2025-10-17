extends Node3D

const PLAYER_POS_INCREASER: int = 1

@export var player_scene: PackedScene

# Multiplayer Stuff
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.load_time()
	SaveScript._save(global.current_save)
	print(SaveScript._save(global.current_save))
	if not global.multiplayer_on:
		var player = player_scene.instantiate()
		add_child(player, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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


func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player, true)
	player.position.y += PLAYER_POS_INCREASER
