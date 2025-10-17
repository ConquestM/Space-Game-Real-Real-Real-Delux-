extends Control

const CURRENTLY_SELECTED_ARRAY: Array = [
	0,
	1,
	2,
	3,
	4,
	5
]

@export var selectable_areas: Array = [
	Node2D,
	Node2D
]
@export var selecter: Polygon2D
var currently_selected: int = 0
@export var planet1: String
@export var loading_screen: Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.can_player_interact = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Player_1_Left"):
		currently_selected -= CURRENTLY_SELECTED_ARRAY[1]
	if Input.is_action_just_pressed("Player_1_Right"):
		currently_selected += CURRENTLY_SELECTED_ARRAY[1]
	currently_selected = clampi(
		currently_selected, CURRENTLY_SELECTED_ARRAY[0], CURRENTLY_SELECTED_ARRAY[1]
	)
	selecter.global_position = get_node(selectable_areas[currently_selected]).global_position
	if Input.is_action_just_pressed("Player_1_Settings"):
		global.loading_screen_active = false
		queue_free()
	if (
		Input.is_action_just_pressed("Player_1_Accept") 
		or Input.is_action_just_pressed("Player_1_Interact")
	):
		if currently_selected == CURRENTLY_SELECTED_ARRAY[0]:
			await get_tree().create_timer(0.05).timeout
			global.can_player_interact = true
			global.loading_screen_active = false
			queue_free()
			if not global.can_player_move_camera:
				global.can_player_move_camera = true
				global.can_player_move = true
				global.exitspaceui = true
		if currently_selected == CURRENTLY_SELECTED_ARRAY[1]:
			_load_scene(global.current_save)
			if not global.can_player_move_camera:
				global.can_player_move_camera = true
				global.can_player_move = true
				global.exitspaceui = true


func _load_scene(_save_file: int):
	global.current_save = _save_file
	loading_screen.selected_scene = SaveScript._load(_save_file)
	loading_screen.selected_scene = str(planet1)
	loading_screen._start()
	loading_screen.show()
