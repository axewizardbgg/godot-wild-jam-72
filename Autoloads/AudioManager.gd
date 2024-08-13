extends Node

# We'll need to reference some a few things
@onready var _animPlayer: AnimationPlayer = $AnimationPlayer
@onready var _bgm1: AudioStreamPlayer = $BGM1
@onready var _bgm2: AudioStreamPlayer = $BGM2

const dayTheme: AudioStream = preload("res://Sounds/Dayness.ogg")
const darkTheme: AudioStream = preload("res://Sounds/TheDarknessTrimmed.ogg")

var currentlyPlaying: String = "day"

func _ready():
	# Ensure volume of Audio tracks are initialized
	# (This was a problem during testing, kept having to reset volumes)
	_bgm1.volume_db = 0
	_bgm2.volume_db = -80

# Crossfades the background music
func crossfadeBGM(theme: String) -> void:
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if _bgm1.playing and _bgm2.playing:
		return

	# What theme are we wanting to play?
	var bgm: AudioStream = dayTheme
	if theme == "dark":
		bgm = darkTheme
			
	# The `playing` property of the stream players tells us which track is active. 
	# If it's track two, we fade to track one, and vice-versa.
	if _bgm2.playing:
		_bgm1.stream = bgm
		_bgm1.play()
		_animPlayer.play("FadeToBGM1")
	else:
		_bgm2.stream = bgm
		_bgm2.play()
		_animPlayer.play("FadeToBGM2")
	# Update our currentlyPlaying
	currentlyPlaying = theme
