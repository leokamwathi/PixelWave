extends Node

export var Enabled := bool(true)
export var SpinRate := float(100)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Enabled : 
		return
	get_parent().get_node_or_null("Img").global_rotation += SpinRate
