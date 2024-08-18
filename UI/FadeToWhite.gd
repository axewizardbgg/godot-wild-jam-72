extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create a tween to fade to white!
	var tween: Tween = get_tree().create_tween()
	var finalVal: Color = $ColorRect.color
	finalVal.a = 1
	tween.tween_property($ColorRect, "color", finalVal, 4.5)
