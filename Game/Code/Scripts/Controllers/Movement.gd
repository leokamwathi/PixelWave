extends Node
export var speed := Vector2(500.0,500.0)
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	direction = get_direction(delta)
	var velocity = speed * direction.normalized()
	get_parent().position += velocity*delta
	
func get_direction(delta):
	direction = Vector2(
		Input.get_action_strength("Right")-Input.get_action_strength("Left"),
		Input.get_action_strength("Down")-Input.get_action_strength("Up")
	)
	return direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



