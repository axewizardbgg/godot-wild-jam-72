extends Node2D

var lit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# We don't want to emit a light until we are lit by the player
	$PointLight2D.energy = 0
	# Add ourselves to the shrines group so the player can interact with us easier
	add_to_group("shrines")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_regen_area_entered(area: Area2D):
	# Have we already been lit?
	if lit:
		# We've already been lit, do nothing
		return
	# We're not yet lit, are we colliding with a player?
	if !area.owner.is_in_group("player"):
		# Nope, do nothing
		return
	# Yes we are encountering the player, LET THERE BE LIGHT! 
	# First we'll play the sound
	$AudioStreamPlayer.play()
	# Next let's make a tween to interpolate our light energy
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($PointLight2D, "energy", 2, 1).set_trans(Tween.TRANS_BOUNCE)
	# Finally, we'll set that we are now lit
	lit = true
	owner.shrinesLit += 1
