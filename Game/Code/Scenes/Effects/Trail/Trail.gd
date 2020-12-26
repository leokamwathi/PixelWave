extends Node2D

export var maxPoints := int(60)
onready var innerTrialWidth = $InnerTrail.width
onready var outterTrialWidth = $OutterTrial.width


func _ready():
	
	#get_parent().get_parent().add_child($MyTrail,true)
	#$MyTrail.drawTrail(get_parent().position)
	#position = Vector2.ZERO
	global_position = Vector2.ZERO
	global_rotation = 0
	pass

#func _process(delta):
func _physics_process(delta):
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
	maxPoints = int(100*(300.0/get_parent().CurrentSpeed)*clamp((Engine.get_frames_per_second()/60.0),0.1,1)) #int(30 * (300.0/get_parent().CurrentSpeed)) * (Engine.get_frames_per_second()/60.0)
	drawTrail(get_parent().position/get_parent().scale , $InnerTrail)
	drawTrail(get_parent().position/get_parent().scale , $OutterTrial)
	modulate = get_parent().get_parent().get_parent().get_node("ColorArray").getNextColorInArray(true)
	pass

func drawTrail(pos, trial):
	global_rotation = 0
	if trial.get_point_count()  > clamp(Engine.get_frames_per_second(),1,60):
			trial.remove_point(0)
	
	#if(pos == point):
	#	return
	#var oPos = trial.get_point_position(trial.get_point_count()-1)
	#if trial.get_point_count() > 0 && oPos.distance_to(pos) > get_viewport().size.y/2:
		#trial.clear_points()
	#	pass
	
	trial.add_point(pos)
	print(trial.get_point_count() )	

