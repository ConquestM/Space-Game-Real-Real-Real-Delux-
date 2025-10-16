extends Enemy


func _process(_delta: float) -> void:
	if hitbox_leap.overlaps_body(global.player) and is_jump == false:
		can_leap = false
		is_jump = true
		velocity = (global.player.position - position)
		velocity.y = JUMP_HEIGHT
		leap_cd.start()
		move_and_slide()
	if hitbox_attack.overlaps_body(global.player) and can_attack == true:
		can_attack = false
		global.health -= HEALTH_REMOVER
		attack_cd.start()
