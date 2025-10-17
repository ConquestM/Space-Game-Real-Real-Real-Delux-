extends Node

signal objective_completion

# 
func _objective_connect():
	get_node("/root/Tutorial/TutorialDialogueUi").objective_flag.connect(_objective_flash)


# To let the player know when they've completed and objective
func _objective_flash():
	objective_completion.emit()
