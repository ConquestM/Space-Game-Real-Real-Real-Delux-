extends StaticBody3D

@export var resource: Node
@export var anim_player: AnimationPlayer

var id = get_instance_id()
var float_height: float = 2.6


func _process(_delta: float) -> void:
	# Checks if the object has been interacted with by checking the most recently interacted object
	if global.collected_object == instance_from_id(id):
		global.collected_object = null
		if name == "Button_Bridge":
			# Plays the animation and raises the bridge if the button is the button_bridge button
			anim_player.play("Button")
			get_tree().current_scene.bridge_button()
			get_tree().current_scene.get_node("TutorialDialogueUi").req_array[7] = true


func _on_button_area_body_entered(body: Node3D) -> void:
	# Checks if a crewmate is nearby and runs a script on it.
	if body is Crewmate:
		body._run_after_navi("Tutorial_Button")
		body.moving = false
