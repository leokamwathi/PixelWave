extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	scale = Vector2(get_parent().CurrentScale,get_parent().CurrentScale)
	if !get_parent().mirror:
		modulate = Color(1.0,0.0,0.5,1.0)
	else:
		modulate = Color(1.0,1.0,1.0,1.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
