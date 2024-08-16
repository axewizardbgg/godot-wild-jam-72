extends CharacterBody2D

signal dangerChanged(danger: bool)

var hp: int = 3
var moveSpd: float = 50 # pixels per second
var regen: bool = false # If we're regenerating light, it goes up, otherwise it decays
var lightLevel: float = 1 # 0 to 1, used to determine the energy of our light
var lightDecayRate: float = 0.02 # Per second
var lightDecayModifier: float = 1 # Percentage, used to scale it up or down depending on items

# Keep track of how many enemies we've spawned
var raccoons: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Add ourselves to the player group so other nodes can identify us
	add_to_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
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
	if lightLevel > 1:
		lightLevel = 1
	# Adjust the light
	_adjustLight()
	

func _decay(delta: float):
	# Decrease our lightLevel by our decayRate
	lightLevel -= lightDecayRate * delta
	# Ensure we don't go below 0
	if lightLevel <= 0:
		lightLevel = 0
	# Adjust the light
	_adjustLight()

# Handling when a raccoon despawns
func _raccoonGone():
	raccoons -= 1

# Auto-created functions from connecting signals in node inspector

func _on_area_2d_area_entered(area: Area2D):
	# Have we encountered a Shrine?
	if area.owner.is_in_group("shrines"):
		# Yes, we're near a shrine, regenerate our light!
		regen = true


func _on_area_2d_area_exited(area: Area2D):
	# Have we encountered a Shrine?
	if area.owner.is_in_group("shrines"):
		# We've left a shrine, stop regen and give in to the decay...
		regen = false
