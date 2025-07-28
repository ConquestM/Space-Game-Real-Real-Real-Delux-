extends Crewmate


const CREW_UI_SCENE: PackedScene = preload("res://Scenes/UI/crew_ui.tscn")
@export var navigation_agent: NavigationAgent3D
var id = get_instance_id()
var moving = false


func _process(_delta: float) -> void:
	if global.collected_object == instance_from_id(id) and global.can_player_move:
		var crew_ui = CREW_UI_SCENE.instantiate()
		
		add_child(crew_ui)
		global.can_player_move = false
		


func _search_for_move_to():
	_setup_movement()
	for i in get_tree().get_nodes_in_group("go_there"):
		target = i
		moving = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if moving == true:
		if navigation_agent.is_navigation_finished():
			return
		else:
			var current_agent_position: Vector3 = global_position
			var next_path_position: Vector3 = navigation_agent.get_next_path_position()

			velocity = current_agent_position.direction_to(next_path_position) * move_speed
			move_and_slide()


func _setup_movement():
	
	await get_tree().physics_frame
	
	navigation_agent.target_position = target.position
