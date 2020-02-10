extends Node2D

func _physics_process(delta):
	#print(scale)
	#0.5/scale.x,0.5/scale.y
	var s := float(1.0/get_parent().scale.x)
	scale = Vector2(s,s)
	global_position = Vector2.ZERO
	rotation = -get_parent().get_rotation()