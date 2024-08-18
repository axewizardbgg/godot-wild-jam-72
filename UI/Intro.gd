extends Control

var gameScene: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Instance the main game scene behind the scenes so we can quickly switch to it
	gameScene = preload("res://main.tscn").instantiate()
	# Create a tween to bring the text up smoothly
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Label, "position", Vector2($Label.position.x, -348), 60)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		startGame()

func startGame():
	# Add the main scene to the tree
	get_tree().root.add_child(gameScene)
	# Destroy ourselves
	queue_free()
