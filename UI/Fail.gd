extends Control

# Expected to be set before _ready()
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Fail screen created!")
	# Pause the game
	get_tree().paused = true
	# Set our alpha to 0
	modulate.a = 0
	# Set up a tween to interpolate the alpha while the wizard is talking
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 12).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.finished.connect(resetToLastShrine)
	print("Doing the thing!")


# Reload the game at the last shrine
func resetToLastShrine():
	# Move the player back to the last shrine
	player.global_position = player.lastShrineEncounteredPos
	# Reset health and light
	player.lightLevel = player.maxLight
	player.hp = 5
	# Create another tween to fade out
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
	tween.finished.connect(func (): self.queue_free())
	# Unpause the game
	get_tree().paused = false
