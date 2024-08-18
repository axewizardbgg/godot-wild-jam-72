extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create a tween to fade out the tutorial overlay
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0), 10).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func (): self.queue_free())
	# Play the Wizard saying the tutorial lol
	AudioManager.playWizardSound("res://Sounds/WizardTutorial1.ogg")
