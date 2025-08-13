extends CharacterBody3D

@export var player: Node
@export var nav_agent: Node
const SPEED: int = 4 
var jump_velocity: int = 0


func _ready() -> void:
	velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:
	nav_agent.set_target_position(player.global_transform.origin)
	var next_path_position = nav_agent.get_next_path_position()
	var current_position = global_transform.origin
	velocity.x = (next_path_position.x - current_position.x)
	velocity.z = (next_path_position.z - current_position.z)
	velocity = Vector3(velocity.x, velocity.y, velocity.z).normalized() * SPEED
	move_and_slide()

func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body):
	if body is Player:
		print("jump")
		velocity.y = jump_velocity
		print(velocity.y)
		print(velocity)
	
