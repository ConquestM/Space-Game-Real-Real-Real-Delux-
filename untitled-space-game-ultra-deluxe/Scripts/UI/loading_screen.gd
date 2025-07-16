extends Control


@export var get_progress_from: Node2D
@export var progress_bar: ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = lerp(progress_bar.value, (get_progress_from.loading_progress[0] * 100), delta)
	if progress_bar.value > 99:
		progress_bar.value = 100
