extends Node2D

signal lightBugDone

# Should be set before _ready is called
var player: CharacterBody2D
# Let's make this scene usable in the Title Screen too
@export var forTitleScreen: bool = false

# We'll randomize the color for variety
var colors: Array = [
	Color("00ffaf"),
	Color("00ff64"),
	Color("00ff28"),
	Color("00d8ff"),
	Color("ff00c3")
]

var count: int = 0
var countMax: int = randi_range(3, 5)
var tweens: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Pick our color, and have it also affect our light too
	$PointLight2D.modulate = randi() % colors.size()-1
	# We'll start out invisible
	modulate.a = 0
	$PointLight2D.energy = 0
	# Start a tween to make up fade in
	var fadeTween: Tween = get_tree().create_tween()
	fadeTween.tween_property(self, "modulate", Color(1,1,1,1), 0.5).set_ease(Tween.EASE_IN)
	fadeTween.tween_property($PointLight2D, "energy", 1, 0.5).set_ease(Tween.EASE_IN)
	# Connect the signal to move it once its faded in
	fadeTween.finished.connect(_setMovement)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# Are we spawned on the title screen?
	if forTitleScreen:
		# Yes, do nothing
		return
	# Are we too far from the player?
	if is_instance_valid(player):
		if global_position.distance_to(player.global_position) > 150:
			# We are too far
			_done()

# We'll pick a random point somewhere nearby and set a tween to move us to it
func _setMovement():
	modulate.a = 1
	# Are we done?
	if count >= countMax:
		# We're done. Fade out!
		var fadeTween: Tween = get_tree().create_tween()
		fadeTween.tween_property(self, "modulate", Color(1,1,1,0), 2)
		fadeTween.tween_property($PointLight2D, "energy", 0, 2)
		# Connect signal for when we're done
		fadeTween.finished.connect(_done)
	# Not done yet, increment count
	count += 1
	# Pick a random point nearby
	var dest: Vector2 = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	# Handle special case if we're for the Title Screen
	if forTitleScreen:
		dest = Vector2(randf_range(0, 320), randf_range(0, 180))
	# Rotate ourselves to face where we are moving to
	$Sprite2D.global_rotation = ((global_position+dest) - global_position).angle()
	# Handle special case if we're for the Title Screen
	if forTitleScreen:
		$Sprite2D.global_rotation = (dest - global_position).angle()
	# We'll need a tween to have it move around the map
	var moveTween: Tween = get_tree().create_tween()
	# Are we for the TitleScreen?
	if forTitleScreen:
		moveTween.tween_property(self, "global_position", dest, randf_range(6,12)).set_trans(Tween.TRANS_BOUNCE)
	else:
		moveTween.tween_property(self, "global_position", global_position + dest, randf_range(4,10)).set_trans(Tween.TRANS_BOUNCE)
	# Connect signal once we're done
	moveTween.finished.connect(_setMovement)
	

# Emit signal we're done, and destroy ourselves
func _done():
	emit_signal("lightBugDone")
	queue_free()
