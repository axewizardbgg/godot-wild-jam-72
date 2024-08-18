extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Play the chomp animation!
	$AnimatedSprite2D.play()

# Once the animation finishes, we want to freeze on the last frame and fade out
func _on_animated_sprite_2d_animation_finished() -> void:
	# Let's create a tween to fade out and destroy ourself after
	var finalVal: Color = Color(0.5, 0.5, 0.5, 0)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", finalVal, 1)
	tween.finished.connect(func (): self.queue_free())
