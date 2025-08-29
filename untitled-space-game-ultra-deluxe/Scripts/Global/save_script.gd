extends Node

var current_scene = "res://Scenes/Gameplay Scenes/Non-Planetoid/tutorial.tscn"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _save_game(current_save: int):
	var save_file = FileAccess.open("user://savegame.save" + str(current_save), FileAccess.WRITE)
	
	save_file.store_line("a")
	print("saved")
