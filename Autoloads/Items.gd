extends Node

var list: Dictionary = {
	"elvisWig": {
		"sprPath": "res://sprites/elvisQuacksly.png",
		"title": "Elvis Quacksly",
		"cost": 0.0,
		"desc": "Doesn't seem to have any real adverse effects, however you can't take it off. You're stuck looking this way, truly the most cursed item.\n\nCost: None\nEffect: You look stupid lol"
	},
	"boots": {
		"sprPath": "res://sprites/duckboots.png",
		"title": "High-Heeled Boots",
		"cost": 0.5,
		"desc": "These don't fit you (thankfully), but for some reason you feel a bit faster while you hold them. It seems to absorb some of your light however...\n\nCost: -5% Max. Light\nEffect: Faster Move Speed"
	},
	"duckTape": {
		"sprPath": "res://sprites/ducktape.png",
		"title": "'Duck' Tape",
		"cost": 0.5,
		"desc": "It's strange seeing your face for the logo... It's even stranger how you feel like this might help slow enemies down, and how your light feels weaker...\n\nCost: -5% Max. Light\nEffect: Temporarily sticks enemies in place when they attack you"
	},
	"moonGlasses": {
		"sprPath": "res://sprites/moonglasses.png",
		"title": "Moon Glasses",
		"cost": 0.5,
		"desc": "Why would you wear these when the impending darkness consumes the world? You don't know, but what you do know is that the darkness seems slower to descend at the cost of a little bit of your light...\n\nCost: -5% Max. Light\nEffect: Light Decay Rate reduced"
	},
	"backpack": {
		"sprPath": "res://sprites/duckpackItem.png",
		"title": "Duckpack",
		"cost": 0.0,
		"desc": "A backpack that seems to be especially made for a Duck! You don't feel any adverse effects... but it does look silly. Allows you to hold other items.\n\nCost: None\nEffect: You can carry items"
	},
	"helmet": {
		"sprPath": "res://sprites/doomhelmet.png",
		"title": "Action Figure Helmet",
		"cost": 0.5,
		"desc": "A tremor of fear courses through you as you pick up this Helmet from an action figure. It leeches a little bit if your light, but you sense enemies will think twice about chasing you...\n\nCost: -5% Max. Light\nEffect: Enemies wait longer before attacking"
	},
	"shotgun": {
		"sprPath": "res://sprites/shotgun.png",
		"title": "Shotgun",
		"cost": 0.5,
		"desc": "A small duck-sized Shotgun... Absolutely useless as there's no ammo, and you can't even fit your wing in the trigger well... You still feel a bit safer carrying it anyway.\n\nCost: -5% Max. Light\nEffect: Enemies wait longer before chasing you"
	},
	"lighter": {
		"sprPath": "res://sprites/lighter.png",
		"title": "Lighter",
		"cost": 0.0,
		"desc": "A perfectly normal lighter! Feels a bit empty, but there's still some fire juice left in it. Perfect for emergencies when your light gets too low...\n\nCost: None\nEffect: At 0% Light, this Lighter is consumed and your Light restored"
	}
}
