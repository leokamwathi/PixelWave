extends Node2D

onready var neon_texture = get_node('Neon_Texture')
onready var neon_beam = get_node('Neon_Beam')
onready var playerNode = get_parent().get_parent()

export var neon_color:= Color(0.0,0.0,0.0)

var isActive := false
var totalRotation := float(0.0)

func _ready():
	scale.x = 0.001
	scale.y = 10
	neon_texture = get_node('Neon_Texture')
	neon_beam = get_node('Neon_Beam')
	neon_texture.visible = false
	neon_beam.visible = false
	deactivate()

func _physics_process(delta):
	#(rand_range(1,36)*100)
	if isActive:
		if Input.get_action_strength("player_special_5") <= 0:
			totalRotation = 0.0
			deactivate()
		if playerNode && playerNode.position.x >= 0:			
			scale.x = 0.1 * (1+playerNode.scale.x)
			position = playerNode.position
		totalRotation += 360*delta
		rotation += deg2rad(totalRotation)
		if totalRotation >= 360:
			totalRotation = 0.0
			deactivate()
		
func setColor(color):
	if (neon_texture):
		neon_texture.modulate = color	
		
func activate(initialAngle=0):
	isActive = true
	totalRotation += initialAngle
	#scale.x = (rand_range(0.01,0.05))
	rotation = deg2rad(initialAngle)
	if (neon_texture):
		neon_texture.visible = true
		neon_beam.visible = true
		#if playerNode:
		#	var baseScale = float(playerNode.scale.x/2) + 0.1
		#	scale.x = baseScale


func deactivate():
	if (neon_texture):
		neon_texture.visible = false
		neon_beam.visible = false
		totalRotation = 0.0
	isActive = false
