extends Node2D

export var maxPoints := int(50)
onready var innerTrialWidth = $InnerTrail.width
onready var outterTrialWidth = $OutterTrial.width


func _ready():
	
	#get_parent().get_parent().add_child($MyTrail,true)
	#$MyTrail.drawTrail(get_parent().position)
	#position = Vector2.ZERO
	global_position = Vector2.ZERO
	global_rotation = 0
	pass

func _process(delta):
	#position = Vector2.ZERO
	global_position = Vector2.ZERO
	global_rotation -= global_rotation
	if get_parent().mirror:
		$InnerTrail.width = innerTrialWidth * (get_parent().CurrentScale*0.75)
		$OutterTrial.width = outterTrialWidth * (get_parent().CurrentScale*0.75)
	else:
		$InnerTrail.width = innerTrialWidth * (get_parent().CurrentScale*0.95)
		$OutterTrial.width = outterTrialWidth * (get_parent().CurrentScale*0.95)
	#rotate(-global_rotation)

	#$MyTrail.rotation = 0
	#$MyTrail.global_rotation = 0
	maxPoints = int(30 * (300.0/get_parent().CurrentSpeed))
	drawTrail(get_parent().position/get_parent().scale , $InnerTrail)
	drawTrail(get_parent().position/get_parent().scale , $OutterTrial)
	modulate = get_parent().get_parent().get_parent().get_node("ColorArray").getNextColorInArray(true)
	pass

func drawTrail(pos, trial):
	global_rotation = 0
	#if get_point_count()  > 10:
	#		remove_point(0)
	#if(pos == point):
	#	return
	var oPos = trial.get_point_position(trial.get_point_count()-1)
	if trial.get_point_count() > 0 && oPos.distance_to(pos) > get_viewport().size.y/2:
		#trial.clear_points()
		pass
	
	trial.add_point(pos)

