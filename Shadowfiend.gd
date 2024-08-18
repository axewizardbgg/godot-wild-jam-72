extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# All we gotta do for this weirdo is add them to a group so the player
	# can check if we're colliding with them
	add_to_group("void")
