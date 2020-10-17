extends Node
export var Enabled := bool(true)
export var MaxSize := float(3.0)
export var MinSize := float(0.5)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if !Enabled :
		return
	if event.is_action("Grow"):
		get_parent().CurrentScale += 0.1
	if event.is_action("Shrink"):
		get_parent().CurrentScale -= 0.1
	if get_parent().CurrentScale > MaxSize:
		get_parent().CurrentScale = MaxSize
	if get_parent().CurrentScale < MinSize:
		get_parent().CurrentScale = MinSize
