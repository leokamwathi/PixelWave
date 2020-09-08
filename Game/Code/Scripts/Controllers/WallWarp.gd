extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	warpWalls(delta)


func warpWalls(delta):
	#stop if you touch the walls
	#what about spwan on otherside 
	if get_parent().position.x < 0:
		get_parent().position.x = get_viewport().size.x+1
	elif get_parent().position.x > get_viewport().size.x:
		get_parent().position.x = 1
	
	if get_parent().position.y < 0:
		get_parent().position.y = get_viewport().size.y+1
	elif get_parent().position.y > get_viewport().size.y:
		get_parent().position.y = 1
	get_parent().position.x = clamp(get_parent().position.x, 0, get_viewport().size.x)
	get_parent().position.y = clamp(get_parent().position.y, 0, get_viewport().size.y)	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
