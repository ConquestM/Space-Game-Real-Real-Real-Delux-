# Class Name
class_name Crewmate

# Inherits
extends CharacterBody3D

# Class Variables
@export_group("Code Stuff") ## Stuff used in code for help, such as raycasts
@export var raycast: RayCast3D ## Raycast to find target
@export_group("Pathfinding") ## Stuff used in pathfinding code. 
@export var target: Node3D ## Target it will move towards
@export_group("Individual Stats")
@export_range(0, 50, 5) var health: float = 50 ## Current Health of the Crew Member
@export_range(0, 10, 1) var move_speed: float = 5 ## Current move_speed of the Crew Member
@export var gender: String = "Female" ## Crew Member's Gender
@export_group("Inventory") ## Edit what the crew member has on them
@export var weapon: String = "Fists" ## Put a string in of the weapons names in order to let the code know what stats to use
