extends CharacterBody3D
class_name Enemy


@export var nav_agent: Node
@export var attack_cd: Timer
@export var leap_cd: Timer
@export var hitbox_leap: Node
@export var hitbox_attack: Node
const SPEED: int = 4 
const JUMP_HEIGHT: int = 6
const HEALTH_REMOVER: int = 10
var can_leap: bool = true
var can_attack: bool = true
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


func _on_attack_cd_timeout():
	can_attack = true


func _on_leap_cd_timeout():
	can_leap = true
