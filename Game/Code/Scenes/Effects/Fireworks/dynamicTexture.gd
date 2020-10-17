extends CanvasItem 
var rect = Rect2(Vector2(0,0),Vector2(20,20))
var rect2 = Rect2(Vector2(-20,-20),Vector2(20,20))
var color = Color(1.0,1.0,1.0)
var color2 = Color(0.5,0.5,0.5,0.5)
var scale = 1
func _draw(): 
	rect.grow(scale)
	rect2.grow(scale)
	#draw_rect(rect,color) 
	draw_rect(rect,color) 
		
func _ready(): 
	update()

func _process(delta):
	pass
	#scale = Vector2(get_parent().CurrentScale,get_parent().CurrentScale)
	#if !get_parent().mirror:
	#	modulate = Color(1.0,0.0,0.5,1.0)
	#else:
	#	modulate = Color(1.0,1.0,1.0,1.0)
