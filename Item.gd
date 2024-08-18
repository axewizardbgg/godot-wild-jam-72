extends Node2D

# Expected to be set before _ready() is called
var itemName: String

# Will be set in _ready()
var player: CharacterBody2D

var startCount: int = 3
var started: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the player
	player = get_tree().get_nodes_in_group("player")[0]
	$Sprite2D.texture = load(Items.list[itemName].sprPath)
	# Set the radius of our CollisionShape2D's shape to be half of our Sprite
	$Area2D/CollisionShape2D.shape.radius = $Sprite2D.texture.get_size().x
	# Spawn about 50px away from the player, get direction we need to go
	var goLeft: bool = (player.global_position.x > global_position.x)
	# Set a destination vector so we can do some funny work with a tween
	var dest: Vector2 = Vector2(1,0) * 50
	if goLeft:
		dest = Vector2(-1,0) * 50
	# Set up a tween to move us to where we will be landing
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", global_position+dest, 1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	# Finally, add ourselves to the items group
	add_to_group("items")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
