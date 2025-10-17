extends Node

var current_save: String = ""
var save: ConfigFile = ConfigFile.new()


func _save(file_no: int):
	current_save = "res://Saves/save" + str(file_no) + ".cfg"
	global.current_scene = get_tree().current_scene.scene_file_path
	save.set_value("Save Info", "Current_Scene", global.current_scene)
	save.save(current_save)
	print(current_save)


func _load(file_no: int):
	current_save = "res://Saves/save" + str(file_no) + ".cfg"
	save.load(current_save)
	
	
	print(save.get_value("Save Info", "Current_Scene"))
	return save.get_value("Save Info", "Current_Scene")
