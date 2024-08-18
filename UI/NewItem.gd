extends Control

# Expected to be set before _ready()
var title: String
var desc: String

func _ready() -> void:
	# Set our UI elements
	$MC/VBC/Title.text = title
	$MC/VBC/Desc.text = desc

func _on_button_continue_pressed() -> void:
	# Unpause the game, and destroy ourselves
	get_tree().paused = false
	queue_free()
