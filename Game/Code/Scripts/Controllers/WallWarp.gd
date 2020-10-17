extends Node

export var Enabled := bool(true)
export var MirrorMode := bool (false)
export var mode := str("Bounce")
var borderLine := Line2D.new()
#var Canvas := Node2D.new()
var hasLine := bool (false)
var oldXY := Vector2.ZERO

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	createLine()
	pass # Replace with function body.

func createLine():
	oldXY = get_viewport().size
	borderLine.visible = false
	borderLine.clear_points()
	if get_parent().mirror:
		return
	borderLine.width = 5
	#borderLine.default_color(1.0,1.0,1.0,1.0)
	borderLine.add_point(Vector2(0,0))
	borderLine.add_point(Vector2(0,get_viewport().size.y))
	borderLine.add_point(Vector2(get_viewport().size.x,get_viewport().size.y))
	borderLine.add_point(Vector2(get_viewport().size.x,0))
	borderLine.add_point(Vector2(0,0))
	
	
	#Canvas.add_child(borderLine)
	get_tree().root.get_child(0).get_node("Base2D").add_child(borderLine)
	#get_tree().root.get_child(0).get_node("Base2D").add_child(Canvas)
	#$Base2D.add_child(borderLine)
	
func _physics_process(delta):
	if !Enabled:
		return
	if mode == "Warp":
		borderLine.visible = false
		get_parent().position = warpWalls(get_parent().position, delta)
		if !get_parent().mirror:
			get_parent().get_parent().absolutePosition = warpWalls(get_parent().get_parent().absolutePosition , delta)
	elif mode == "Bounce":
		if(oldXY != get_viewport().size):
			get_parent().transform.origin = get_viewport().size/2
			createLine()
		borderLine.visible = true
		borderLine.width = 5
		get_parent().position = bounceWalls(get_parent().position,delta)
		if !get_parent().mirror:
			get_parent().get_parent().absolutePosition = bounceWalls(get_parent().get_parent().absolutePosition , delta)
	elif mode == "Pass":
		borderLine.visible = false
		
	if mode != "Pass":	
		#get_parent().position.x = clamp(get_parent().position.x, 0, get_viewport().size.x)
		#get_parent().position.y = clamp(get_parent().position.y, 0, get_viewport().size.y)
		pass

func _input(event):
	if event.is_action_pressed("WallEffect"):
		if mode == "Bounce":
			mode = "Warp"
		elif mode == "Warp":
			mode = "pass"
		else:
			mode = "Bounce"

func showLine():
	pass
	
func warpWalls(pos,delta):
	#stop if you touch the walls
	#what about spwan on otherside 
	if pos.x <= 0:
		pos.x = get_viewport().size.x+1
	elif pos.x >= get_viewport().size.x:
		pos.x = 1
	
	if pos.y <= 0:
		pos.y = get_viewport().size.y+1
	elif pos.y >= get_viewport().size.y:
		pos.y = 1
	return pos
	#get_parent().position.x = clamp(get_parent().position.x, 0, get_viewport().size.x)
	#get_parent().position.y = clamp(get_parent().position.y, 0, get_viewport().size.y)	

func bounceWalls(pos,delta):
	#stop if you touch the walls
	#what about spwan on otherside 
	if pos.x < 0:
		borderLine.width = 10
		pos.x = get_viewport().size.x * 0.05
	elif pos.x > get_viewport().size.x:
		borderLine.width = 10
		pos.x = get_viewport().size.x * 0.95
	
	if pos.y < 0:
		borderLine.width = 10
		pos.y = get_viewport().size.x*0.05
	elif pos.y > get_viewport().size.y:
		borderLine.width = 10
		pos.y = get_viewport().size.y - get_viewport().size.x*0.05
	return pos

