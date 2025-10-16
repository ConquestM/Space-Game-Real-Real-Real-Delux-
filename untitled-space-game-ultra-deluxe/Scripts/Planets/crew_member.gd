extends Crewmate


const CREW_UI_SCENE: PackedScene = preload("res://Scenes/UI/crew_ui.tscn")
@export var navigation_agent: NavigationAgent3D
@export var wait_timer: Timer
var id = get_instance_id()
var moving = false
var moved_to = [null]
var ui_open: bool = false


# Checks if interacted with if so, adds circle crew UI
func _process(_delta: float) -> void:
	pass


# Search for the closest thing to move to 
func _search_for_move_to():
	# if we are in the tutorial, advance the dialogue.
	if name == "Tutorial_NPC":
		get_tree().current_scene.get_node("TutorialDialogueUi").req_array[8] = true
	
	for i in get_tree().get_nodes_in_group("go_there"):
		if i == moved_to.back():
			return
		else:
			target = i
			moving = true


func _physics_process(delta: float) -> void:
	# Gravity, NOTE - NOT WORKING RIGHT NOW
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Checks to see if the npc should be moving
	if moving == true:
		# Checks to see if the target is real, to avoid crashing the game
		if target == null:
				return
		else:
			# Sets the pathfinding pos constantly
			navigation_agent.target_position = target.position
		
		# Navigate pathfinding while moving is active
			var current_agent_position: Vector3 = global_position
			var next_path_position: Vector3 = navigation_agent.get_next_path_position()

			velocity = current_agent_position.direction_to(next_path_position) * move_speed
			move_and_slide()


func _run_after_navi(object_type: String):
	print(object_type)
	moving = false
	moved_to.append(target)
	target = null
	if object_type == "Tutorial_Button":
		get_tree().current_scene._end_tutorial()


func _spawn_ui():
	var crew_ui = CREW_UI_SCENE.instantiate()
	
	if not ui_open:
		add_child(crew_ui)
		global.can_player_move = false
		ui_open = true


func _wait_ui():
	wait_timer.start()


func _on_wait_for_ui_timer_timeout() -> void:
	ui_open = false
