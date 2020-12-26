extends Line2D
func _ready():
	#position = get_parent().get_parent().position
	#modulate = Color (0.0,1.0,0.0,1.0)
	pass
#func _process(delta):
func _physics_process(delta):
	#drawTrail()
	#add_point(get_local_mouse_position())
	#position = get_local_mouse_position()
	if get_point_count()  > get_parent().maxPoints:
		remove_point(0)
	pass
	
#func _physics_process(delta):
	#default_color = modulate
	#modulate = myColor #Color(rand_range(0.0,1.0),rand_range(0.0,1.0),rand_range(0.0,1.0),1.0)
	#drawTrail()
	
#	pass


	
