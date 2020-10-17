extends Node
export var Enabled := bool(true)
export var MaxSpeed := float (5000)
export var MinSpeed := float (100)
var newPos = Vector2.ZERO

var speed := float (300.0)
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = get_parent().CurrentSpeed
	
	pass
	
func _physics_process(delta):
	if !Enabled:
		return
	if get_parent().mirror:
		return
	if !get_parent().get_parent().absoluteSet:
		get_parent().get_parent().absoluteSet = true
		get_parent().get_parent().absolutePosition = get_parent().position
	direction = get_direction(delta).rotated(-get_parent().get_parent().rotateBy)
	var velocity = speed * direction.normalized()
	get_parent().position += (velocity*delta)
	get_parent().get_parent().absolutePosition += (velocity*delta)
	if (get_parent().position != newPos):
		get_parent().get_parent().alignPlayers();
	newPos = get_parent().position
	
	
func get_direction(delta):
	direction = Vector2(
		Input.get_action_strength("Right")-Input.get_action_strength("Left"),
		Input.get_action_strength("Down")-Input.get_action_strength("Up")
	)
	return direction
func _input(event):
	if !Enabled :
		return
	if !get_parent().mirror:
		if event.is_action_pressed("Centered"):
			get_parent().get_parent().absolutePosition = get_viewport().size/2
		if event.is_action_pressed("ThirdY"):
			get_parent().get_parent().absolutePosition.x = get_viewport().size.x/2
			get_parent().get_parent().absolutePosition.y = get_viewport().size.y/3	
		if event.is_action_pressed("ThirdX"):
			get_parent().get_parent().absolutePosition.y = get_viewport().size.y/2
			get_parent().get_parent().absolutePosition.x = get_viewport().size.x/3
		#
	if event.is_action_pressed("Centered"):
		get_parent().position = get_viewport().size/2
	if event.is_action_pressed("ThirdY"):
		get_parent().position.x = get_viewport().size.x/2
		get_parent().position.y = get_viewport().size.y/3	
	if event.is_action_pressed("ThirdX"):
		get_parent().position.y = get_viewport().size.y/2
		get_parent().position.x = get_viewport().size.x/3
	if event.is_action("SpeedUp"):
		speed += 50
		get_parent().get_parent().get_parent().get_node("ColorArray").setSpeed(speed)
	if event.is_action("SpeedDown"):
		speed -= 50
		get_parent().get_parent().get_parent().get_node("ColorArray").setSpeed(speed)
	if speed > MaxSpeed:
		speed = MaxSpeed
	if speed < MinSpeed:
		speed = MinSpeed
	get_parent().CurrentSpeed = speed
	



