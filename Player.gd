extends CharacterBody2D

signal dangerChanged(danger: bool)
signal itemAcquired(item: String)
signal playerDied

# How many hits we can take before we die
var hp: int = 5
# How fast we move
var moveSpd: float = 50 # pixels per second
# If we're regenerating light, it goes up, otherwise it decays
var regen: bool = false 
# How much light we eminate
var lightLevel: float = 1 # 0 to 1, used to determine the energy of our light
# Maximum light
var maxLight: float = 1 # Reduced by cursed items
# The speed at which our light wanes
var lightDecayRate: float = 0.02 # Per second
var lightDecayModifier: float = 1 # Can be increased by shadowfiends
# What items we currently have
var items: Array = []
# Keep track of which Shrine we last encountered
var lastShrine: Node2D
# Where we first encountered the last shrine, so we can respawn here if needed.
var lastShrineEncounteredPos: Vector2 = global_position
# Keep track of how many enemies we've spawned
var raccoons: int = 0
# Random flags for things we've encountered, so we can play wizard voice lines
var vlRaccoon: bool = false
var vlRaccoonBit: bool = false
var vlShadowfiend: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add ourselves to the player group so other nodes can identify us
	add_to_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# Do we need to quack?
	if Input.is_action_just_released("Quack"):
		# Pick a random quack sound
		var quack: Array = [
			"res://Sounds/quack1.ogg",
			"res://Sounds/quack2.ogg",
			"res://Sounds/quack3.ogg"
		]
		var pick: int = randi() % quack.size()
		# Set the audio stream of the sound player and play sound
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stream = load(quack[pick])
		$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.2)
		$AudioStreamPlayer.play()
	# Handle light decay or regen
	if regen:
		_regen(delta)
	else:
		_decay(delta)
	# Update the UI (I know we're supposed to signal up, but whatever, GAMEJAM BABY)
	get_tree().root.get_node("Main").hud.updateLightLevel(lightLevel)
	# Handle input and movement
	var motion: Vector2
	if Input.is_action_pressed("Up"):
		motion.y -= 1
	if Input.is_action_pressed("Left"):
		motion.x -= 1
	if Input.is_action_pressed("Down"):
		motion.y += 1
	if Input.is_action_pressed("Right"):
		motion.x += 1
	# Did we move?
	if motion == Vector2.ZERO:
		# Nope, do nothing
		if $AnimatedSprite2D.animation != "default":
			$AnimatedSprite2D.animation = "default"
			$AnimatedSprite2D2.animation = "default"
			$AnimatedSprite2D3.animation = "default"
		return
	# We moved, normalize the vector
	motion = motion.normalized()
	# Scale the vector
	motion = motion * (moveSpd)
	# Apply our motion and move
	velocity = motion
	move_and_slide()
	# translate(motion)
	# Animate our sprite
	if $AnimatedSprite2D.animation != "walk":
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D2.play("walk")
		$AnimatedSprite2D3.play("walk")
	# Which direction do we need to face?
	var ang: float = rad_to_deg(motion.angle())
	if ang > 90 || ang < -90:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D2.flip_h = true
		$AnimatedSprite2D3.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D2.flip_h = false
		$AnimatedSprite2D3.flip_h = false
	# Do we need to update the rotation of our last shrine arrow?
	if !is_instance_valid(lastShrine):
		# No, we're done
		return
	# Yes
	$LastShrineArrow.rotation = (lastShrine.global_position-global_position).angle()

# Adjust light variables
func _adjustLight():
	# Adjust the energy of our light, but I don't want it to get below 0.5, so we'll scale it
	$PointLight2D.energy = lerp(0.5, 1.0, lightLevel)
	# We'll also adjust the texture scale too, the largest it should ever be is 4,
	# and the smallest is should ever be is 2.
	$PointLight2D.texture_scale = lerp(2.0, 4.0, lightLevel)
	# Also adjust the saturation of our duck as it gets darker
	$AnimatedSprite2D.modulate = lerp(Color(0.5, 0.5, 0.5, 1), Color(1, 1, 1, 1), lightLevel)
	$AnimatedSprite2D2.modulate = $AnimatedSprite2D.modulate
	$AnimatedSprite2D3.modulate = $AnimatedSprite2D.modulate
	# Kinda random to throw this in here too, but do we need to change the music?
	if lightLevel < 0.25:
		# We should be playing Dark theme, are we playing it already?
		if AudioManager.currentlyPlaying != "dark":
			# We're not playing it, play it!
			AudioManager.crossfadeBGM("dark")
			# Also trigger that we're in danger!
			emit_signal("dangerChanged", true)
	elif lightLevel < 0.50:
		# Have we spawned some enemies?
		if raccoons < 1:
			# Spawn a raccoon!
			var r: Node2D = load("res://Raccoon.tscn").instantiate()
			r.player = self
			var dir = deg_to_rad(randf_range(0, 359))
			var rPos: Vector2 = Vector2(1,0).rotated(dir) * 180
			get_tree().root.get_node("Main").add_child(r)
			r.global_position = global_position + rPos
			raccoons += 1
			r.raccoonGone.connect(_raccoonGone)
			# Is this the first raccoon we've spawned?
			if !vlRaccoon:
				# It is, play wizard voice line and set flag to true
				AudioManager.playWizardSound("res://Sounds/WizardRaccoonWarning.ogg")
				vlRaccoon = true
	else:
		# We should be playing Day theme, are we playing it already?
		if AudioManager.currentlyPlaying != "day":
			# We're not playing it, play it!
			AudioManager.crossfadeBGM("day")
			# Also emit signal that we're no longer in danger
			emit_signal("dangerChanged", false)

# Handle regen and decay
func _regen(delta: float):
	# Should take about 3 seconds to fully recharge, that and should be noticable on screen.
	lightLevel += 0.33 * delta
	# Ensure we're don't go over 1 (we could, but it would be super bright)
	if lightLevel > maxLight:
		lightLevel = maxLight
	# Adjust the light
	_adjustLight()
	

func _decay(delta: float):
	# Decrease our lightLevel by our decayRate
	lightLevel -= (lightDecayRate * lightDecayModifier) * delta
	# Ensure we don't go below 0
	if lightLevel <= 0:
		lightLevel = 0
		# Do we have a lighter?
		if items.has("lighter"):
			# Consume the lighter to refill your light!
			lightLevel = maxLight
			items.erase("lighter")
			# Play the sound effect of the lighter
			$AudioStreamPlayer.stop()
			$AudioStreamPlayer.stream = load("res://Sounds/torchlit.ogg")
			$AudioStreamPlayer.play()
	# Adjust the light
	_adjustLight()

# Handling when a raccoon despawns
func _raccoonGone():
	raccoons -= 1

# Handling when we pick up an item
func pickUpItem(itemName: String):
	# Add the item to our list
	items.append(itemName)
	# Apply item affects (Note: Some effects aren't specified here, and are
	# accounted for on other relevant scenes (Such as the Racoon)
	match itemName:
		"backpack":
			# We have the backpack, show it on our character
			$AnimatedSprite2D3.visible = true
			AudioManager.playWizardSound("res://Sounds/WizardItemDiscovery.ogg")
		"elvisWig":
			# We picked up this damn wig lol, show it on our character
			$AnimatedSprite2D2.visible = true
		"boots":
			moveSpd = 60
			maxLight -= 0.05
		"moonGlasses":
			maxLight -= 0.05
			lightDecayRate = 0.015
		"duckTape":
			maxLight -= 0.05
		"helmet":
			maxLight -= 0.05
		"shotgun":
			maxLight -= 0.05
	# Finally, emit a signal that we picked up an item
	emit_signal("itemAcquired", itemName)

# Take damage!
func takeDamage():
	hp -= 1
	if hp <= 0:
		# Game Over! Well not really, just restart at last shrine
		AudioManager.playWizardSound("res://Sounds/WizardFail.ogg")
		# Prepare the fail scene
		var fail: Control = load("res://UI/Fail.tscn").instantiate()
		fail.player = self
		# Add it to our UI layer
		get_tree().root.get_node("Main/CanvasUILayer").add_child(fail)
	# Update our health bar
	$HealthBar.value = float(hp)
	# Set healthbar to be visible, and make a tween to fade it out
	$HealthBar.modulate.a = 1
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($HealthBar, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.5).set_ease(Tween.EASE_IN)
	# Is this the first time we got bit?
	if !vlRaccoonBit:
		# It is, play the wizard voice line
		AudioManager.playWizardSound("res://Sounds/WizardDontForgetToDuck.ogg")
		vlRaccoonBit = true

# Auto-created functions from connecting signals in node inspector
func _on_area_2d_area_entered(area: Area2D):
	# Is the thing we are colliding with still a valid instance?
	if !is_instance_valid(area.owner):
		# No, do nothing
		return
	# Have we encountered a Shrine?
	if area.owner.is_in_group("shrines"):
		# Is this our first shrine?
		if !is_instance_valid(lastShrine):
			# Yes this is our first shrine, show the arrow back to it, and also
			# display the tutorial.
			$LastShrineArrow.visible = true
			# TODO
			pass
		# Yes, we're near a shrine, regenerate our light!
		regen = true
		# Mark this as the last shrine we visited
		lastShrine = area.owner
		lastShrineEncounteredPos = global_position
		return
	# Have we encountered an item?
	if area.owner.is_in_group("items"):
		# We have an item, do we have a backpack?
		if !items.has("backpack"):
			# We don't... Is this item the backpack?
			if area.owner.itemName != "backpack":
				# We can't pick this item up yet, do nothing
				return
		# Yes, add it to our list of items
		pickUpItem(area.owner.itemName)
		# Destroy the item
		area.owner.queue_free()
	# Are we encountering the void?
	if area.owner.is_in_group("void"):
		# We are! Incrase our light decay!
		lightDecayModifier = 3
		# Is this the first time we've encountered the void?
		if !vlShadowfiend:
			# It is, play the wizard voice line and set flag to true
			AudioManager.playWizardSound("res://Sounds/WizardKeepYourDistance.ogg")
			vlShadowfiend = true


func _on_area_2d_area_exited(area: Area2D):
	# Is the thing we are colliding with still a valid instance?
	if !is_instance_valid(area.owner):
		# No, do nothing
		return
	# Have we encountered a Shrine?
	if area.owner.is_in_group("shrines"):
		# We've left a shrine, stop regen and give in to the decay...
		regen = false
	# Have we encountered the void?
	if area.owner.is_in_group("void"):
		# We left the void, reset our light decay modifier
		lightDecayModifier = 1
