extends Area2D

export var speed = 600
export var canPiercing:= true
export var pierceChance:= 0.65

var vel = Vector2()
var parentPlayer
var damage = 1
var isActive := bool(0)


func _ready():
	add_to_group("playerBullet")
	
func start_at(rot,pos,mod,parent):
	rotation = rot
	position = pos+Vector2(mod,0).rotated(rotation)
	vel = Vector2(speed,0).rotated(rotation)
	parentPlayer = parent
	activate()

func deactivate():
	isActive = false
	self.monitorable = false
	self.set_visible(false)

func activate():
	isActive = true
	self.monitorable = true
	self.set_visible(true)
	get_node("lifetime").start(1.0)

func setTexture(newTexture):
	get_node("Sprite").set_texture(newTexture)

func setColor(newColor):
	#get_node("particleColor").set_modulate(newColor)
	get_node("GlowSprite/spriteColor").set_modulate(newColor)
	
func _physics_process(delta):
	if isActive:
		position = position+vel*delta

func updatePlayerScore(val):
	parentPlayer.updatePlayerScore(val)

func _on_lifetime_timeout():
	deactivate()
	#queue_free()
