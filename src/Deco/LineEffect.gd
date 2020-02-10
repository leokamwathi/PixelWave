extends Line2D

class lineEffectClass:
	var effectType: String
	var currentValue: float
	var radiusRateValue: float
	var minPointsValue: int
	var maxPointsValue: int
	var maxValue: int
	var stepValue: int
	var widthValue: float
	var rotationRateValue: float
	var rotationOffsetValue: float
	
var isActive = false
var lineEffect = lineEffectClass.new()
var drawCoolDown = 0
var currentColor := Color(1.0,1.0,1.0,1.0)
var drawCooldown = 0
export var skipframes = 3

func setPoints(newPoints):
	clear_points()
	for p in range(newPoints.size()-1):
		set_points(newPoints[p])

func _physics_process(delta):
	clear_points()
	if isActive:
		var playerNode = get_parent().get_parent()
		currentColor = playerNode.getNextColorInArray()
		var color =currentColor
		var pos = Vector2.ZERO #playerNode.global_position + global_position #
		#width = lineEffect.widthValue #*playerNode.scale.x
		if drawCoolDown < 1 || lineEffect.currentValue > lineEffect.maxValue*0.05:
			drawCoolDown = clamp(int((Engine.get_frames_per_second()/60)*skipframes),0,skipframes)
			if lineEffect.effectType == 'heart':
				width =  lineEffect.widthValue * 4
				draw_heart(pos,lineEffect.currentValue*playerNode.scale.x,lineEffect.maxPointsValue,lineEffect.minPointsValue,color )
			else:
				width =  lineEffect.widthValue * 4
				draw_line_effect(pos,lineEffect.currentValue*playerNode.scale.x,lineEffect.radiusRateValue,lineEffect.maxPointsValue,lineEffect.minPointsValue,color,lineEffect.widthValue,lineEffect.rotationRateValue,lineEffect.rotationOffsetValue)
			#if lineEffect.rotationRateValue != -1:
			#	rotate(playerNode.rotation * lineEffect.rotationRateValue)
		drawCoolDown-= 1
		global_rotation = playerNode.rotation + playerNode.rotation * lineEffect.rotationRateValue
		global_position = playerNode.global_position
		scale = playerNode.scale
		
		lineEffect.currentValue += lineEffect.stepValue*(60 * delta)
		if lineEffect.currentValue*scale.x > lineEffect.maxValue:
			deactivate()
	else:
		clear_points()

func setTexture(tex):
	texture = tex

func setColor(col):
	modulate = col

func activate(effect):
	isActive = false
	clear_points()
	lineEffect = effect
	isActive = true

func deactivate():
	isActive = false
	lineEffect = lineEffectClass.new()
	clear_points()

func heart_x(r,f):
	var xCord := float((16/f) * sin(r)* sin(r)* sin(r))
	#print(xCord)
	return xCord

func heart_y(r,f):
	var yCord := float((13/f) * cos(r) - 5/f*cos(2*r)-2/f*cos(3*r)-1/f*cos(4*r))
	#print(yCord)
	return yCord
	
	
func draw_heart(center,radius,maxPoints,minPoints,color):
	setColor(color)
	clear_points()
	#center = Vector2(0,0)
	var playerNode = get_parent().get_parent()
	var linePoints = PoolVector2Array()	
	var angleDegrees = maxPoints
	var f = 1.0 #(201-radius)/100
	if maxPoints != minPoints:
		angleDegrees = clamp(int((Engine.get_frames_per_second()/60)*maxPoints),minPoints,maxPoints)
	angleDegrees = clamp(int(angleDegrees/4),18,90)*2
	var segemntAngle = 180/angleDegrees # draw half then mirror it
	radius = radius * 0.1
	
	for segemnt in range(angleDegrees):
		var angleRadians = deg2rad(segemntAngle*segemnt)
		linePoints.push_back(center + Vector2(radius*heart_x(angleRadians,f),radius*heart_y(angleRadians,f)).rotated(deg2rad(180)))
	
	for point_index in range(linePoints.size()-1):
			add_point(linePoints[point_index])
	
	for point_index in range(linePoints.size()-1):
		add_point(linePoints[(linePoints.size()-1)-point_index]*Vector2(-1,1))
			
	if linePoints.size() > 0 :
		add_point(linePoints[0])
		#[linePoints.size()-1
	if(angleDegrees != linePoints.size()):
		print(linePoints.size())
		print(points.size())

func draw_line_effect(center,radius,radiusRate,maxPoints,minPoints,color,lineWidth=3,rotateRate=1,rotationOffset=0):
	setColor(color)
	clear_points()
	var playerNode = get_parent().get_parent()
	#position = playerNode.global_position-playerNode.position
	#global_rotation = playerNode.global_rotation #-playerNode.rotation
	var isDuo = radiusRate>0
	var points = maxPoints
	if maxPoints != minPoints:
		points = clamp(int((Engine.get_frames_per_second()/60)*maxPoints),minPoints,maxPoints)
	var linePoints = PoolVector2Array()	
	var linePointsDuo = PoolVector2Array()
	var segemntAngle = 360/points
	
	for i in range(points+1):
		var angle_point = deg2rad(segemntAngle*i - 90)
		#linePoints.push_back((center + Vector2(cos(angle_point), sin(angle_point)) * radius).rotated(deg2rad(rotationOffset) + playerNode.global_rotation*rotateRate -deg2rad(90)))
		linePoints.push_back((center + Vector2(cos(angle_point), sin(angle_point)) * radius))
		if isDuo:
			linePointsDuo.push_back((center + Vector2(cos(angle_point+deg2rad(segemntAngle/2)), sin(angle_point+deg2rad(segemntAngle/2))) * radius*radiusRate)) #.rotated(deg2rad(rotationOffset)+deg2rad(segemntAngle/2) + global_rotation*rotateRate -deg2rad(90)))
	for point_index in range(linePoints.size()-1):
		if isDuo:
			add_point(linePoints[point_index])
			add_point(linePointsDuo[point_index])
		else:
			add_point(linePoints[point_index])
	if linePoints.size() > 1 :
		add_point(linePoints[0])
		if isDuo:
			add_point(linePoints[0])
		else:
			add_point(linePoints[1])
	#if rotateRate == -1:
		#rotation = playerNode.rotation
	

	
	

