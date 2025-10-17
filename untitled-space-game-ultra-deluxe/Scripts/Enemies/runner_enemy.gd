extends Enemy

func _process(_delta: float) -> void:
	# If the player is in range and the enemy can attack, attack
	if hitbox_attack.overlaps_body(global.player) and can_attack == true:
		can_attack = false
		global.health -= HEALTH_REMOVER
		attack_cd.start()
