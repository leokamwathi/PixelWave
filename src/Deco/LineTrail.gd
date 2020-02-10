extends Line2D
var point = Vector2.ZERO
var myColor := Color(1.0,1.0,1.0,1.0)

func _ready():
	#modulate = Color (0.0,1.0,0.0,1.0)
	pass
func _process(delta):
	#add_point(get_local_mouse_position())
	#position = get_local_mouse_position()
	pass
	
func _physics_process(delta):
	#default_color = modulate
	modulate = myColor #Color(rand_range(0.0,1.0),rand_range(0.0,1.0),rand_range(0.0,1.0),1.0)
	pass
	