extends Node
#export (PackedScene) var startUpScene

onready var game = get_node("Game")

func _ready():
	game.visible = true
	pass # Replace with function body.
