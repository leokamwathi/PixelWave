extends Node2D


onready var neon_texture = get_node('Neon_Texture')
onready var neon_beam = get_node('Neon_Beam')
onready var playerNode = get_parent().get_parent().get_node("player")

export var neon_color:= Color(0.0,0.0,0.0)

var isActive := false
var baseSpeed = 1.0

func _ready():
	scale.x = 0.05
	scale.y = 5
	position.y = 370
	neon_texture = get_node('Neon_Texture')
	neon_beam = get_node('Neon_Beam')
	neon_texture.visible = false
	neon_beam.visible = false
	deactivate()


func _physics_process(delta):

	if isActive:
		var baseSpeed  = 0
		if playerNode:
				baseSpeed = float(playerNode.scale.x*300)
				scale.x = 0.05 + (0.25 * playerNode.scale.x) 
		if position.x < 1368:
			position.x += (750+baseSpeed)*delta
		else:
			deactivate()
		
func setColor(color):
	if (neon_texture):
		neon_texture.modulate = color	
		
func activate():
	isActive = true
	if (neon_texture):
		neon_texture.visible = true
		neon_beam.visible = true
		if playerNode:
			var baseScale = float(playerNode.scale.x/2) + 0.1
			scale.x = baseScale
	position.x = 0

func deactivate():
	if (neon_texture):
		neon_texture.visible = false
		neon_beam.visible = false
	isActive = false
