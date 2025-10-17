extends Control

@export var playtime: Label


func _process(_delta: float) -> void:
	playtime.text = "Playtime: " + str(global.time)


func _on_timer_timeout():
	global.time += 1
	global.save_time()
