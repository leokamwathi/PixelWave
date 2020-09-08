extends Line2D
var point = Vector2.ZERO
var myColor := Color(1.0,1.0,1.0,1.0)

func _ready():
	#position = get_parent().get_parent().position
	#modulate = Color (0.0,1.0,0.0,1.0)
	pass
func _process(delta):
	#drawTrail()
	#add_point(get_local_mouse_position())
	#position = get_local_mouse_position()
	pass
	
func _physics_process(delta):
	#default_color = modulate
	#modulate = myColor #Color(rand_range(0.0,1.0),rand_range(0.0,1.0),rand_range(0.0,1.0),1.0)
	#drawTrail()
	pass

func drawTrail(pos):
	global_rotation = 0
	#if get_point_count()  > 10:
	#		remove_point(0)
	#if(pos == point):
	#	return
	point = pos
	add_point(pos)
	if get_point_count()  > get_viewport().size.y/10:
		remove_point(0)
	
