extends Control

# Preload the TitleScreen so we can go back to it
var titleScreen: Node2D

# Put a 2s period in case the user was still trying to mash keys
var skippable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	titleScreen = load("res://TitleScreen.tscn").instantiate()
	# Create a tween to scroll our text
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($ScrollingStuff, "position", Vector2($ScrollingStuff.position.x, -751), 120)

# Player can press any key to return to menu
func _input(event: InputEvent) -> void:
	if !skippable:
		return
	if event is InputEventKey:
		# Add the title screen scene to the tree
		get_tree().root.add_child(titleScreen)
		# Destroy ourselves
		queue_free()


func _on_timer_timeout() -> void:
	skippable = true
