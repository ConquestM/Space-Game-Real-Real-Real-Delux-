extends Enemy

func _process(_delta: float) -> void:
	# If player is in range and the enemy isn't already jumping, jump
	if hitbox_leap.overlaps_body(global.player) and is_jump == false:
		can_leap = false
		is_jump = true
		# Jumps towards the player
		velocity = (global.player.position - position)
		velocity.y = JUMP_HEIGHT
		leap_cd.start()
		move_and_slide()
	# If the player is in range and the enemy can attack, attack
	if hitbox_attack.overlaps_body(global.player) and can_attack == true:
		can_attack = false
		global.health -= HEALTH_REMOVER
		attack_cd.start()
