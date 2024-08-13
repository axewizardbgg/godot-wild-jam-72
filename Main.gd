extends Node2D


# Get some nodes we'll need to manage
@onready var hud: Control = $CanvasUILayer/HUD

# Keep track of how many shrines we've lit
var shrinesLit: int = 0 # There are 8 shrines total

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create some light bugs and add them to the scene around the player
	var count: int = 0
	while count < 5:
		_spawnLightBug()
		count += 1
		
	pass # Replace with function body.

# Respawn light bug
func _spawnLightBug():
	# Get the player position
	var playerPos: Vector2 = $Player.global_position
	# Pick an area around there
	var offsetPos: Vector2 = Vector2(randf_range(-160, 160), randf_range(-90, 90))
	# Spawn our bug
	var bug: Node2D = load("res://LightBug.tscn").instantiate()
	# Add it to our scene
	get_tree().root.add_child.call_deferred(bug)
	# Set the position
	bug.global_position = playerPos + offsetPos
	# Connect signal
	bug.lightBugDone.connect(_spawnLightBug)
	# Add a reference to the player
	bug.player = $Player
