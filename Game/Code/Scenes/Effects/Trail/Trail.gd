extends Node2D

func _ready():
	#$MyTrail.drawTrail(get_parent().position)
	#position = Vector2.ZERO
	global_position = Vector2.ZERO
	global_rotation = 0
	pass

func _process(delta):
	#position = Vector2.ZERO
	global_position = Vector2.ZERO
	global_rotation -= global_rotation
	#rotate(-global_rotation)

	#$MyTrail.rotation = 0
	#$MyTrail.global_rotation = 0
	
	$MyTrail.drawTrail(get_parent().position)
	pass
