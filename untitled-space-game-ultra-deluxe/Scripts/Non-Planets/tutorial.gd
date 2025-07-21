extends Node3D


var can_move_body: bool = false
var body_real: Node3D
@export var lerp_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move_body:
		body_real.get_node("Collision").disabled = true
		body_real.velocity = Vector3(0, 0, 0)
		body_real.position = lerp(body_real.position, global.last_player_pos, (delta * 2))


# Move player back to where they jumped from
func _on_respawn_body_entered(body: Node3D) -> void:
	global.can_player_move = false
	can_move_body = true
	body_real = body
	lerp_timer.start()


func _on_lerptimer_timeout() -> void:
	global.can_player_move = true
	can_move_body = false
	body_real.get_node("Collision").disabled = false
