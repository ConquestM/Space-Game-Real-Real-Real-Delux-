extends Enemy

func _process(_delta: float) -> void:
	if hitbox_attack.overlaps_body(global.player) and can_attack == true:
		can_attack = false
		global.health -= HEALTH_REMOVER
		attack_cd.start()
