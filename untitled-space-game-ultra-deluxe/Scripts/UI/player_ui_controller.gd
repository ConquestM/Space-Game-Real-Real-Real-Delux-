extends Control

@export var crosshair: Sprite2D
const CROSSHAIR_LERP_SPEED: int = 4
const CROSSHAIR_LERP_SIZE_MAX: Vector2 = Vector2(0.3, 0.3)
const CROSSHAIR_LERP_SIZE_MIN: Vector2 = Vector2(0.15, 0.15)
var functioned_yet: bool = false
var shown: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If the player raycast is colliding with something interactable, then change the crosshair for player feedback.
	if get_parent().looking.is_colliding():
		if get_parent().looking_object.has_meta("Name") or get_parent().looking_object.get_parent().has_meta("Name"):
			# Changes the size of the crosshair smoothly
			crosshair.scale = lerp(
				crosshair.scale, CROSSHAIR_LERP_SIZE_MAX, delta * CROSSHAIR_LERP_SPEED
			)
			#If the object the player raycast detects has a name in it's metadata, display it above the crosshair.
			if get_parent().looking_object.has_meta("Name"):
				crosshair.get_node("Name").text = get_parent().looking_object.get_meta("Name")
			elif get_parent().looking_object.get_parent().has_meta("Name"):
				crosshair.get_node("Name").text = get_parent().looking_object.get_parent().get_meta("Name")
			if not functioned_yet:
				_timer()
				functioned_yet = true
				shown = true
	else:
		# Shrinks Crosshair when not looking at something
		crosshair.scale = lerp(
			crosshair.scale, CROSSHAIR_LERP_SIZE_MIN, delta * CROSSHAIR_LERP_SPEED
		)
		if functioned_yet:
			_timer()
			functioned_yet = false
			shown = false


func _timer():
	crosshair.get_node("NameTimer").start()


# Controls visibility of the text display
func _on_name_timer_timeout() -> void:
	crosshair.get_node("Name").visible = shown
