extends Control

@export var playtime: Label


# Shows the playtime
func _process(_delta: float) -> void:
	playtime.text = "Playtime: " + str(global.time)


# Increase the player's playtime and saves it
func _on_timer_timeout():
	global.time += 1
	global.save_time()
