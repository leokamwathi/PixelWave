extends Line2D


func heart_x(r,f):
	return 16/f * sin(r)* sin(r)* sin(r)

func heart_y(r,f):
	return 13/f * cos(r) - 5/f*cos(2*r)-2/f*cos(3*r)-1/f*cos(4*r)
	
	
func draw_heart(center,radius,maxPoints,minPoints,color):
	position = Vector2(500,500)
	center = Vector2(0,-3)
	var playerNode = get_parent().get_parent()
	var linePoints = PoolVector2Array()	
	var angleDegrees = 360 #maxPoints
	var f = 1.0 #(201-radius)/100
	#if maxPoints != minPoints:
	#	points = clamp(int((Engine.get_frames_per_second()/60)*maxPoints),minPoints,maxPoints)
	var segemntAngle = 1 #360/points
	radius = 10
	var step = 8
	#for step in range(8):
	for angle in range(angleDegrees):
		var angleRadians = deg2rad(angle)
		linePoints.push_back(Vector2(radius*heart_x(angleRadians,f),radius*heart_y(angleRadians,f)).rotated(deg2rad(180)))

	for point_index in range(linePoints.size()-1):
			add_point(linePoints[point_index])
	if linePoints.size() > 1 :
		pass
		#add_point(linePoints[0])
func _ready():
	draw_heart(Vector2(50,50),100,360,360,Color(1.0,0.5,0.2))
	pass
func _draw():
	pass
	#draw_heart(Vector2(50,50),100,360,360,Color(1.0,0.5,0.2))
	
func _physics_process(delta):
	#update()
	pass
	