extends Node2D

signal raccoonGone

# Expected to be set before _ready
var player: CharacterBody2D

# Determine if we are running away or following the player
var running: bool = false
var moveSpd: float = 40
var bitten: bool = false # So we don't bite player 120 times a second lol
var chaseSoundPlayed: bool = false
var taped: bool = false # For when you bite the player if they have ducktape

# Called when the node enters the scene tree for the first time.
func _ready():
	# Play the spawn sound
	$SndSpawn.play()
	# TODO: Testing this, for not just play the sprite
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# Are we covered in ducktape?
	if taped:
		# We are, do nothing
		return
	# Determine whether or not we are following or running
	if player.lightLevel > 0.5:
		running = true
	else:
		running = false
	# Prepare our motion vector
	var motion: Vector2
	# Handle movement if we're running
	if running:
		# We're running, just run away from the player
		motion = (global_position - player.global_position).normalized() * (moveSpd * 2 * delta)
		translate(motion)
		_handleSpriteFlip(motion.angle())
		# Are we far enough away from the player to despawn?
		if global_position.distance_to(player.global_position) >= 180:
			# Yes, despawn!
			emit_signal("raccoonGone")
			queue_free()
		# We've handled movement, stop further execution
		return
	# We're not running, we're following the player!
	var chaseThreshold: float = 0.25
	# Determine if the player has the Shotgun
	if player.items.has("shotgun"):
		# Player has the Shotgun, we'll wait longer before chasing the player
		chaseThreshold = 0.1
	# Is it time to chase the player?
	if player.lightLevel >= chaseThreshold:
		# We need to follow but keep a distance, the light is still too bright!
		var dist: float = global_position.distance_to(player.global_position)
		if dist > lerp(60.0, 120.0, player.lightLevel):
			# Move towards player
			var dir: float = (player.global_position-global_position).angle()
			motion = Vector2(1,0).rotated(dir) * (moveSpd * delta)
			translate(motion)
			_handleSpriteFlip(motion.angle())
		elif dist <= lerp(60.0, 120.0, player.lightLevel) * 0.75:
			# We need to move away from the player, we're too close
			var dir: float = (global_position-player.global_position).angle()
			motion = Vector2(1,0).rotated(dir) * (moveSpd * delta)
			translate(motion)
			_handleSpriteFlip(motion.angle())
		# We've moved, stop further execution
		return
	# We're chasing the player! Let's keep increasing movespd so the player 
	# can't outrun us forever
	moveSpd += (2 * delta) # Every second we'll move an extra pixel faster
	# Have we played our chase sound?
	if !chaseSoundPlayed:
		$SndAttack.play()
		chaseSoundPlayed = true
	# How far away are we?
	var dist: float = global_position.distance_to(player.global_position)
	if dist <= 25:
		# We're close enough to attack! Have we already attacked?
		if bitten:
			# Yes, do nothing as it is still on coooldown
			return
		# We've not bitten the player yet, do the thing!
		var biteEffect: Node2D = load("res://BiteEffect.tscn").instantiate()
		player.add_child(biteEffect)
		var bitePos: Vector2 = (player.global_position-global_position).normalized() * 15
		biteEffect.position = Vector2(0, -8)
		biteEffect.rotation = bitePos.angle()
		$SndBite.play()
		# Set our bite to be on cooldown
		bitten = true
		var biteReset: float = 2
		if player.items.has("helmet"):
			biteReset = 3
		var timer: SceneTreeTimer = get_tree().create_timer(biteReset)
		timer.timeout.connect(_resetBite)
		# Does the player have ducktape?
		if player.items.has("duckTape"):
			# They do, we're taped until our bite resets
			taped = true
			$Sprite2D.visible = true
		# Deal damage to the player too!
		player.takeDamage()
		# Stop further execution
		return
	# We're not close enough to bite the player, move closer
	var dir: float = (player.global_position-global_position).angle()
	motion = Vector2(1,0).rotated(dir) * (moveSpd * delta)
	translate(motion)
	_handleSpriteFlip(motion.angle())
	
		

# Function to handle flipping the sprite
func _handleSpriteFlip(ang: float):
	# Convert to degrees first
	ang = rad_to_deg(ang)
	# Which direction do we need to face?
	if ang > 90 || ang < -90:
		$AnimatedSprite2D.scale.x = 1
	else:
		$AnimatedSprite2D.scale.x = -1

func _resetBite():
	bitten = false
	taped = false
	$Sprite2D.visible = false

# Auto-genreated function from connecting signal in node window
func _on_animated_sprite_2d_frame_changed():
	# We'll need to move our Light up or down depending on the frame.
	# Frames 0 and 2 they will moved down 1px, and frames 1, 3 will go up 1px
	# What frame are we on?
	var frame: int = $AnimatedSprite2D.frame
	if frame == 0 || frame == 2:
		# Move down 1 px
		$AnimatedSprite2D/PointLight2D.position.x -= 1
	else:
		$AnimatedSprite2D/PointLight2D.position.x += 1
	pass # Replace with function body.
