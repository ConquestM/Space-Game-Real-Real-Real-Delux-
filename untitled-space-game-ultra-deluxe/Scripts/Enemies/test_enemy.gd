extends CharacterBody3D

@export var player: Node
@export var nav_agent: Node
const SPEED: int = 4 

func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	velocity = (nav_agent.get_next_path_position() - global_transform.origin).normalized() * SPEED
	move_and_slide()

func _process(delta: float) -> void:
	if (player.global_transform.origin - global_transform.origin).normalized() < 10:
		print("jump")
