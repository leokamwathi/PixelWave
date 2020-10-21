extends Node
var mode := str("mirror")
var orbits := int(1)
var rotateBy = 0
var absolutePosition := Vector2.ZERO
var absoluteSet := bool(false)
var particleLifeTime := float(1.5)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#rotateBy = deg2rad(90)
	pass # Replace with function body.
func _process(delta):
	var rotationAngle = deg2rad((get_child(0).CurrentSpeed/200))
	if Input.is_action_pressed("RotateUp"):
		rotateBy += (rotationAngle)
		alignPlayers()
	if Input.is_action_pressed("RotateDown"):
		rotateBy -= (rotationAngle)
		alignPlayers()

func _input(event):
	
	if event.is_action_pressed("ParticleMode"):
		particleLifeTime += 0.5
		if particleLifeTime > 3.0:
			particleLifeTime = 0.0
	
	if event.is_action_pressed("SwitchMode"):
		if mode == "mirror":
			mode = "reflect"
		else:
			mode = "mirror"
	if event.is_action_pressed("AddOrbit"):
		orbits += 1
	if event.is_action_pressed("RemoveOrbit"):
		orbits -= 1
		if orbits < 1 :
			orbits = 1
	
	if rotateBy > deg2rad(360):
		rotateBy = 0
	if rotateBy < 0:
		rotateBy = deg2rad(360)
	
	if event.is_action_pressed("KillNode"):
		if get_child_count()>1:
			get_child(get_child_count()-1).queue_free()
	if event.is_action_pressed("SpawnNode"):
		var p = $PlayerInstance.duplicate()
		p.mirror = true
		p.position = get_child(0).position
		#p.position.x = get_viewport().size.x - p.position.x 
		#p.position.y = get_viewport().size.y - p.position.y
		p.transform.origin = get_viewport().size/2
		add_child(p)
		alignPlayers()
		pass
func getNextColorInArray(isPositive = true):
	return get_parent().get_node("ColorArray").getNextColorInArray(true)

		
func alignPlayers():
	var totalNodes = get_child_count()
	
	if totalNodes == 1:
		return
	var distance = absolutePosition.distance_to(get_viewport().size/2)
	var dangle = absolutePosition.angle_to_point(get_viewport().size/2)
	var sliceAngle = (deg2rad(360)/ totalNodes)
	for i in range(totalNodes):
		var dist = distance
		if i >= 0:
			var carry = i%orbits 
			
			var point = get_viewport().size/2
			
			#n-(ceil(n/o)*2)
			var nodePosition = int(i-(ceil((i*(orbits-1))/float(orbits))))
			var angle = (sliceAngle * (nodePosition) * orbits)
			var rotateAngle = rotateBy
			if mode == "mirror":
				#angle = (sliceAngle * (nodePosition))
				if  nodePosition%2 == 0:
					 angle += dangle
				else:
					 angle -= dangle
					 #rotateAngle = -rotateAngle
			elif mode == "reflect":
				angle += dangle

			dist = distance*(orbits-carry)/orbits
		

			#To place your node at a specific angle around a given point:
			get_child(i).position = (point + Vector2(cos(angle), sin(angle)) * dist)

			#get_child(i).position = point + (get_child(i).position - point).rotated(rotateBy)
			get_child(i).CurrentScale = get_child(0).CurrentScale
			#To make your node rotate around that point, while keeping the same distance:
			#get_child(i).position = get_child(i).position.rotated(rotateBy)
	
			get_child(i).position = point + (get_child(i).position - point).rotated(rotateAngle)
			#To make it look at the point:
			
			#look_at(point)
			#get_child(i).transform2D()
			#get_child(i).position.x = cos(angle) * get_child(0).position.x - get_viewport().size.x/2
			#get_child(i).position.y = sin(angle) * get_child(0).position.y - get_viewport().size.y/2
	pass
