extends KinematicBody2D
class_name Actor

#export var gravity:= 100.0
var velocity:= Vector2.ZERO 
export var speed := Vector2(300.0,300.0)
#	velocity.y = max(velocity.y,speed.y)

func _physics_process(delta):	
	#velocity.y += gravity*delta
	velocity = move_and_slide(velocity)


