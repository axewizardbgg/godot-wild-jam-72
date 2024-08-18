extends Control

# Get the nodes we'll need to manage
@onready var lBar: ProgressBar = $MarginContainer/VBC1/ProgressBar
@onready var sBar: ProgressBar = $MarginContainer/VBC2/ProgressBar
@onready var hBar: ProgressBar = $MarginContainer/VBC4/ProgressBar
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

func updatePlayerHP(val: int):
	# Convert val to a float
	var f: float = float(val)
	hBar.value = f
	
