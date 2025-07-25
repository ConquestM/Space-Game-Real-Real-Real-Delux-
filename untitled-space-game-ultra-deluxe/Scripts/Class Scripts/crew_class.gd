# Class Name
class_name Crewmate

# Inherits
extends AnimatableBody3D

# Class Variables
@export_group("Pathfinding") ## Stuff used in pathfinding code. 
@export var target: Node3D ## Target it will move towards
@export_group("Individual Stats")
@export_range(0, 50, 5) var health: float = 50 ## Current Health of the Crew Member
@export var gender: String = "Female" ## Crew Member's Gender
@export_group("Inventory") ## Edit what the crew member has on them
@export var weapon: String = "Fists" ## Put a string in of the weapons names in order to let the code know what stats to use
