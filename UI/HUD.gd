extends Control

# Get the nodes we'll need to manage
@onready var lBar: ProgressBar = $MarginContainer/VBC1/ProgressBar
@onready var sBar: ProgressBar = $MarginContainer/VBC2/ProgressBar
@onready var vines: TextureRect = $Vines

# Called when the node enters the scene tree for the first time.
func _ready():
	vines.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Function that can be called to update the progress bar
func updateLightLevel(val: float):
	lBar.value = val
	# Also do we need to update our Vines overlay?
"""
	if val >= 0.75:
		vines.visible = false
	elif val >= 0.50:
		vines.visible = true
		vines.texture.current_frame = 0
	elif val >= 0.25:
		vines.visible = true
		vines.texture.current_frame = 1
	else:
		vines.visible = true
		vines.texture.current_frame = 2
"""
