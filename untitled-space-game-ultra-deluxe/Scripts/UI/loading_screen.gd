extends Control

const MAX_PROGRESS: int = 100
@export var get_progress_from: Node2D
@export var progress_bar: ProgressBar
@export var timer: Timer
@export var loading_text: Button
var selected_scene: String
var started_loading: bool = false
var loading_progress: Array = [0]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started_loading:
		ResourceLoader.load_threaded_get_status(selected_scene, loading_progress)
		progress_bar.value = lerp(progress_bar.value, loading_progress[0] * 100, delta * 2)
		if progress_bar.value > 99.5:
			progress_bar.value = MAX_PROGRESS
			started_loading = false
			timer.start()


func _start():
	ResourceLoader.load_threaded_request(selected_scene)
	started_loading = true


func _on_wait_timeout() -> void:
	var load_it_slowly = ResourceLoader.load_threaded_get(selected_scene)
	get_tree().change_scene_to_packed(load_it_slowly)


func _on_timer_timeout() -> void:
	if loading_text.text.contains("..."):
		loading_text.text = "Loading"
	else:
		loading_text.text += "."
