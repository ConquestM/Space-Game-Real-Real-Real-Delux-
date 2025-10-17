extends Node

var hosting: bool = false
var joining: bool = false
var hostip: String = "wait"
var inputedip: String = "localhost"
var port: int = 20277


# Gets the IP of the player from different addresses based on their OS
func _ready() -> void:
	print(IP.get_local_addresses())
	if OS.has_feature("windows"):
		print("windows")
		if OS.has_environment("COMPUTERNAME"):
			hostip = IP.get_local_addresses()[4]
	elif OS.has_feature("linuxbsd"):
		print("linux")
		if OS.has_environment("HOSTNAME"):
			hostip = IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	elif OS.has_feature("macos"):
		print("mac")
		if OS.has_environment("USER"):
			print("mac2")
			hostip = IP.get_local_addresses()[13]
	print(hostip)
