extends Node2D

# Preload our scenes that we'll need to switch to
var introScene: Control
var creditsScene: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Instance the main game scene behind the scenes so we can quickly switch to it
	introScene = preload("res://UI/Intro.tscn").instantiate()
	creditsScene = preload("res://UI/Credits.tscn").instantiate()

func _on_button_start_pressed() -> void:
	# Add the main scene to the tree
	get_tree().root.add_child(introScene)
	# Destroy ourselves
	queue_free()

func _on_button_quit_pressed() -> void:
	# Quit the game
	get_tree().quit()

func _on_button_credits_pressed() -> void:
	# Add the Credits to the scene and destroy ourselves
	get_tree().root.add_child(creditsScene)
	queue_free()
