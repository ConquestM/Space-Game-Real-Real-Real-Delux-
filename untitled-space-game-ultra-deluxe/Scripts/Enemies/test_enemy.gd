extends CharacterBody3D


@export var nav_agent: Node
@export var jump_timer: Node
@export var player_scene: PackedScene
const SPEED: int = 4 
const JUMP_HEIGHT: int = 6
var can_jump: bool = false
var is_jump: bool = false


func _ready() -> void:
	velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		is_jump = false
	if not is_jump:
		nav_agent.set_target_position(global.player.global_transform.origin)
		var next_path_position = nav_agent.get_next_path_position()
		var current_position = global_transform.origin
		velocity.x = (next_path_position.x - current_position.x)
		velocity.z = (next_path_position.z - current_position.z)
		velocity = Vector3(velocity.x, velocity.y, velocity.z).normalized() * SPEED
	move_and_slide()


func _on_area_3d_body_entered(body):
	if body is Player and is_jump == false:
		is_jump = true
		velocity = (global.player.position - position)
		velocity.y = JUMP_HEIGHT
		move_and_slide()


func _on_attack_range_body_entered(body):
	if body is Player:
		global.health -= 10
