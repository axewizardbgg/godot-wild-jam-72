extends Node2D

class_name ForestTree

@export var flip: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# For variety, we'll randomy flip our x axis
	if flip == true:
		scale.x = -1
	# Connect signals
	$AreaHide.area_entered.connect(_hideTree)
	$AreaHide.area_exited.connect(_showTree)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _hideTree(area: Area2D):
	# Is the thing we are colliding with still a valid instance?
	if !is_instance_valid(area.owner):
		# No, do nothing
		return
	# Is this the player or an item?
	if !(area.owner.is_in_group("player") || area.owner.is_in_group("items")):
		# No, do nothing
		return
	# Create a tween to hide the tree
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1,1,1,0.5), 0.5).set_trans(Tween.TRANS_LINEAR)

func _showTree(area: Area2D):
	# Is the thing we are colliding with still a valid instance?
	if !is_instance_valid(area.owner):
		# No, do nothing
		return
	# Is this the player or an item?
	if !(area.owner.is_in_group("player") || area.owner.is_in_group("items")):
		# No, do nothing
		return
	# Create a tween to show the tree
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_LINEAR)
