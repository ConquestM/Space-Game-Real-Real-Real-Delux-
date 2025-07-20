extends Node


var hosting: bool = false
var joining: bool = false
var hostip: String = "wait"
var inputedip: String = "localhost"
var port: int = 20277


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("windows"):
		print("windows")
		if OS.has_environment("COMPUTERNAME"):
			hostip =  IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	elif OS.has_feature("linuxbsd"):
		print("linux")
		if OS.has_environment("HOSTNAME"):
			hostip =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	elif OS.has_feature("macos"):
		print("mac")
		if OS.has_environment("USER"):
			print("mac2")
			hostip = IP.get_local_addresses()[13]
	print(hostip)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
