extends Node


var hosting: bool = false
var joining: bool = false
var hostip: String = IP.get_local_addresses()[5]
var inputedip: String = "localhost"
var port: int = 20277


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(IP.get_local_addresses()[5])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
