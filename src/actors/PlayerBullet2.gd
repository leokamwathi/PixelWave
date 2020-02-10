extends Node2D


export var speed = 600
export var canPiercing:= true
export var pierceChance:= 0.65

onready var tex = get_node('texture2')
var vel = Vector2()
var parentPlayer
var damage = 1
var isActive := bool(0)
var isBullet := bool(0)

func _ready():
	add_to_group("playerBullet")
	tex = get_node('texture2')
	
func start_at(rot,pos,mod,parent):
	rotation = rot
	position = pos+Vector2(mod,0).rotated(rotation)
	vel = Vector2(speed,0).rotated(rotation)
	parentPlayer = parent
	activate()

func deactivate():
	isActive = false
	isBullet= false
	self.set_visible(false)

func activate():
	isActive = true
	self.set_visible(true)
	get_node("lifetime").start(1.5)

func setTexture(newTexture):
	pass
	#get_node("texture").set_texture(newTexture)
	#if tex :
	#	tex.set_texture(newTexture)

func setColor(newColor):
	#print(str(get_modulate()))
	#set_modulate(newColor)
	if tex:
		tex.set_modulate(newColor)
	#get_node("particleColor").set_modulate(newColor)
	#get_node("texture").set_modulate(newColor)
	
func _physics_process(delta):
	if isActive:
		position = position+vel*delta


func updatePlayerScore(val):
	parentPlayer.updatePlayerScore(val)

func _on_lifetime_timeout():
	deactivate()
	#queue_free()