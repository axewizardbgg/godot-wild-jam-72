extends Node2D

# Preload our scenes that we'll need to switch to
var introScene: Control
var creditsScene: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Instance the main game scene behind the scenes so we can quickly switch to it
	introScene = preload("res://UI/Intro.tscn").instantiate()

func _on_button_start_pressed() -> void:
	# Add the main scene to the tree
	get_tree().root.add_child(introScene)
	# Destroy ourselves
	queue_free()

func _on_button_quit_pressed() -> void:
	# Quit the game
	get_tree().quit()

# TODO: Remove this debug test when I figure out mouse input
func _on_button_start_mouse_entered() -> void:
	print("Mouse entered!")
