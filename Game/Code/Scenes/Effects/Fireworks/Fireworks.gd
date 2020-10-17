extends Node2D


export var speed = 600
export var canPiercing:= true
export var pierceChance:= 0.65

onready var tex = get_node('texture')
var vel = Vector2()
var parentPlayer
var damage = 1
var isActive := bool(0)
var isExploding:= bool(0)

func _ready():
	#add_to_group("playerBullet")
	tex = get_node('texture')
	
func start_at(rot,pos,mod,parent):
	rotation = rot
	position = pos+Vector2(mod,0).rotated(rotation)
	parentPlayer = parent
	speed = 300
	vel = Vector2(speed,0).rotated(rotation)
	activate()

func deactivate():
	get_node("lifetime").stop()
	isActive = false
	isExploding= false
	self.set_visible(false)

func activate():
	isActive = true
	#isExploding = true
	self.set_visible(true)
	get_node("lifetime").start(5)

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
		rotation += 0.01
		if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
			deactivate()


func updatePlayerScore(val):
	parentPlayer.updatePlayerScore(val)

func _on_lifetime_timeout():
	deactivate()
	#queue_free()
