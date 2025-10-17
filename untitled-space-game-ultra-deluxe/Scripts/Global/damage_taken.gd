extends Timer


func _on_timeout():
	# Tells the health bar when the player has stopped taking damage
	global.hp_changing = false
