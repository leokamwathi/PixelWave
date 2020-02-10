extends Area2D

onready var bullet_container = get_node("bullet_container")
onready var particleEmitter = get_node("ParticlesEmitter")
onready var line_effect_container = get_node("line_effect_container")
onready var laser_line_effect_container = get_node("laser_line_effect_container")
onready var effects_container = get_node("effects_container")
onready var playerTrail = get_node("trail_container/LineTrail")



export (PackedScene) var bullet
export (PackedScene) var lineEffectNode
export (PackedScene) var EffectNode
export (PackedScene) var laserLineEffectNode

export var isReverse:= bool(0)
export var maxParticle = 100
export var maxScore = 100000000
export (Texture) var playerTexture
export (Color) var playerColor
export var canWallWarp = true
export var maxBulletScale = 1.5
export var speed := Vector2(300.0,300.0)
export var scoreMod = 1000
export var playerNumber = 0
export var baseDamage = 5
export var isEmitting:= false
export var color_array = [Color(.39,.68,.21),Color(1,1,.32),Color(.98,.6,.07),Color(1,.15,.07),Color(.51,0,.65),Color(.07,.27,.98)]
export var color_array2 = [Color(1,1,1)]
export var color_array3 = [Color(1,1,1)]
export var color_array4 = [Color(1,1,1)]

var mouse_position
var isMouseMoving
var playerLevel = 0
var velocity:= Vector2.ZERO 
var isShooting:= bool(0)
var isSpecialShooting := bool(0)
var isMoving:= bool(0)
var currentScore = 0
var screen_size = Vector2(800,600)
var baseSpeed = 300
var isLineTrail = true
var secsFPS = 0
var currentBullet = 0
var currentEffect = 0
var currentLineEffect = 0
var currentLaserLineEffect = 0
var spiralRotation = 0
var arcCoolDown = 0
var screen_center := Vector2.ZERO
var rapidFireCount = 0
var heartCoolDown = 0
var color_index = 0
var colorCoolDown = 10
var isColorMixing := true
var currentColorWheel = 0
var direction = Vector2.ZERO
var currentColor := Color(1.0,1.0,1.0,1.0)
var spinners = 1
var msg_output
var fpsodds = 1



#ARRAYS
var arcsEffects=[]
var diamondsEffects=[]
var diamondsSpinEffects=[]
var lineEffectArray = []
var colorWheel = []
#var color_array = [Color(.39,.68,.21),Color(1,1,.32),Color(.98,.6,.07),Color(1,.15,.07),Color(.51,0,.65),Color(.07,.27,.98)]

class lineEffect:
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
	

func _ready():
	get_node("20x20_rainbow").texture = playerTexture
	get_node("ParticlesEmitter").setTexture(playerTexture)
	add_to_group("player")
	colorWheel = [color_array,color_array2,color_array3,color_array3,color_array4]
	spiralRotation = 5.5
	baseSpeed = speed.x
	screen_size = get_viewport_rect().size
	screen_center = Vector2(screen_size.x,screen_size.y)
	if playerNumber == 1:
		msg_output = get_node("../HUD/Player1Score")
		position.x = screen_size.x * 0.25
		position.y = screen_size.y * 0.5
	if playerNumber == 2:
		msg_output = get_node("../HUD/Player2Score")
		position.x = screen_size.x * 0.75
		position.y = screen_size.y * 0.5
	if playerNumber == 3:
		position.x = screen_size.x * 0.5
		position.y = screen_size.y * 0.25
	if playerNumber == 4:
		position.x = screen_size.x * 0.5
		position.y = screen_size.y * 0.75
	generateBullets()
	generateLineEffects()
	generateLaserLineEffects()
	generateEffects()
	
func getNextColorInArray(forceRotate = false):
	#print(currentColorWheel)
	if color_index > colorWheel[currentColorWheel].size()-1:
		color_index = 0
	if !isColorMixing:
		currentColor= playerColor
	if isReverse:
		currentColor= colorWheel[currentColorWheel][colorWheel[currentColorWheel].size()-color_index-1]
	else:
		currentColor = colorWheel[currentColorWheel][color_index]
	if forceRotate:
		color_index += 1
	return currentColor
	
	
func colorCycle():
	if colorCoolDown==0:
		color_index +=1
		colorCoolDown = int(10 * speed.x/baseSpeed)
	colorCoolDown -= 1
	if color_index > colorWheel[currentColorWheel].size()-1:
		color_index = 0

func generateLineEffects():
	for __ in range(200):
		var l = lineEffectNode.instance()
		#l.setTexture(playerTexture)
		l.deactivate()
		line_effect_container.add_child(l)

func generateLaserLineEffects():
	for __ in range(180):
		var l = laserLineEffectNode.instance()
		#l.setTexture(playerTexture)
		l.deactivate()
		laser_line_effect_container.add_child(l)
		
func generateEffects():
	for __ in range(400):
		var e = EffectNode.instance()
		#l.setTexture(playerTexture)
		e.deactivate()
		effects_container.add_child(e)
func drawTrail():
	if !isLineTrail:
		playerTrail.clear_points()
		return
	playerTrail.width = 20 + int(playerLevel/5)
	if playerTrail.get_point_count()  > 100 + int(playerLevel/2):	
		playerTrail.remove_point(0)
	var f := float(0.665/scale.x)-1.0
	var scaleFactor = Vector2(f/scale.x,f/scale.y)
	playerTrail.add_point(global_position)
	#print(f)
		
func generateBullets():
	var bulletStorm = 3000
	if playerNumber == 20:
		bulletStorm = 4500
	for __ in range(bulletStorm):
		var b = bullet.instance()
		b.setTexture(playerTexture)
		b.deactivate()
		bullet_container.add_child(b)
		
func _process(delta):
	colorCycle()
func showInfo(msg,type='spin'):
	msg = str(playerNumber) + ' <||> ' + str(msg)
	if msg_output && type == 'spin' && playerNumber == 1:
		msg_output.set_text(msg)	
	if msg_output && playerNumber == 2 && type=='web':
		msg_output.set_text(msg)	
	#get_node('info').set_text(msg)
	#get_node('info').set_rotation(0)
	
func _physics_process(delta):
	
	#drawTrail()
	#var delayMs = 6 - clamp(int(Engine.get_frames_per_second()/10),0,6)
	#OS.delay_msec(delayMs)
	if arcCoolDown >0 :
			arcCoolDown -= 1
	modulate = currentColor
	if rapidFireCount > 0:
		rapidFireCount -= 1
	else:
		rapidFireCount = 0
		
	playerSpecials(delta)
	playerMovement(delta)
	
	#if Input.get_action_strength('player_increase_glow')>0:
		#spiralRotation += 0.001
	#	spinners+= 1
		
	#if Input.get_action_strength('player_decrease_glow')>0:
		#spiralRotation -= 0.001
	#	spinners-= 1
	#if spinners<1:
	#	spinners = 1
	#showInfo('rotation_rate : '+ str(spiralRotation))
	#showInfo('spinners : '+ str(spinners))
	
	maxParticle = playerLevel * 5
	if maxParticle > 100:
		maxParticle = 100
		
	#scoreDecay(delta)
	
	if playerNumber == 1:
		if get_node_or_null("../Background"):
			get_node("../Background").playerPosition = position
		#get_node("../HUD/Player1Score").set_text("Player 1 Score : " + str(currentScore) + " Lvl: "+ str(playerLevel))	

	if playerNumber == 2:
		pass
		#get_node("../HUD/Player2Score").set_text("Player 2 Score : " + str(currentScore) + " Lvl: "+ str(playerLevel))		

	if playerLevel <= 100:
		playerLevel = (currentScore*100)/maxScore
		playerLevel = clamp(playerLevel,0,100)
		
	var scaleVal = float(((playerLevel/100.0)*250.0)+50.0)
	scale = Vector2(scaleVal/100,scaleVal/100)
	# draw_trail()
	warpWalls(delta)
	
	#position.x = clamp(position.x, 40, screen_size.x-40)
	#position.y = clamp(position.y, 40, screen_size.y-60)

func updatePlayerScore(val):
	if currentScore < maxScore:
		currentScore += val * (101 - playerLevel)

func toggleParticles():
	isEmitting = !isEmitting
	particleEmitter.isEmitters(isEmitting)


func scoreDecay(delta):
	if currentScore < 0:
		currentScore = 0
	else:
		if isMoving || isShooting:
			currentScore -= int((playerLevel*playerLevel/25)*delta*1000)
		else:
			currentScore -= int((playerLevel*playerLevel/25)*delta*10000)

func playerSpecials(delta):

	if isSpecialShooting==false && isShooting==false && (Input.get_action_strength("player_special_2") > 0 || Input.get_action_strength("player_secondary_shoot")>0 ):
		if playerNumber == fpsodds:
			shoot_spiral()
		if fpsodds == 1:
			fpsodds = 2
		else:
			fpsodds =1
		if Engine.get_frames_per_second()>24 || secsFPS > 24:
			isSpecialShooting = true
			#shoot_spiral()
			secsFPS = 0
		else:
			isSpecialShooting = false
			secsFPS += 1
	else:
		isSpecialShooting = false
	if Input.is_action_just_pressed("player_special_7"):
		if get_parent().isPlaying && playerNumber==2:
			Input.action_release("player_special_7")
		specialEffectGenerator('Triangle')
		specialEffectGenerator('Triangle',false,0.0,'explode')
		specialEffectGenerator('Triangle',false,0.0,'random')
		
	if Input.is_action_just_pressed("player_special_8"):
		if get_parent().isPlaying && playerNumber==2:
			Input.action_release("player_special_8")
		specialEffectGenerator('Star')
		specialEffectGenerator('Star',false,0.0,'explode')
		specialEffectGenerator('Star',false,0.0,'random')
	
	if Input.is_action_just_pressed("player_special_4"):
		if get_parent().isPlaying && playerNumber==2:
			Input.action_release("player_special_4")
		specialEffectGenerator('Circle')
		specialEffectGenerator('Circle',false,0.0,'explode')
		specialEffectGenerator('Circle',false,0.0,'random')
	if Input.is_action_just_pressed("player_special_6"):
		if get_parent().isPlaying && playerNumber==2:
			Input.action_release("player_special_6")
		specialEffectGenerator('Diamond')
		specialEffectGenerator('Diamond',false,0.0,'explode')
		specialEffectGenerator('Diamond',false,0.0,'random')
		
	if Input.is_action_just_pressed("player_special_3"):
		if get_parent().isPlaying && playerNumber==2:
			Input.action_release("player_special_3")
		specialEffectGenerator('Diamond',true,5.0)
		specialEffectGenerator('Diamond',true,5.0,'explode')
		specialEffectGenerator('Diamond',true,5.0,'random')
		
	if Input.is_action_just_pressed("player_special_9"):
		if get_parent().isPlaying && playerNumber==2:
			Input.action_release("player_special_9")
		specialEffectGenerator('Heart')
		specialEffectGenerator('Heart',false,0.0,'explode')
		specialEffectGenerator('Heart',false,0.0,'random')
				
	if Input.get_action_strength("player_special_add") > 0:
		if currentScore < maxScore:
			currentScore += 10000 + int(currentScore * 0.1)
	
	if Input.get_action_strength("player_special_sub") > 0:
		if currentScore > 0:
			currentScore -= 10000 + int(currentScore * 0.05)
	
	if Input.get_action_strength("player_special_1") > 0 :
		#isSpecialShooting==false && isShooting==false &&
		isShooting = true
		#shoot()
		if playerNumber == fpsodds:
			shoot()
		if fpsodds == 1:
			fpsodds = 2
		else:
			fpsodds =1
		
	if Input.get_action_strength("player_primary_gun") > 0 :
		#isSpecialShooting==false && isShooting==false &&
		isShooting = true
		shoot(true)
		if playerNumber == fpsodds:
			#shoot(true)
			#shoot_mid()
			pass
		odds()
	if Input.get_action_strength("player_primary_gun") == 0 :
		isShooting=false
	if Input.is_action_just_pressed("player_feature_7"):
		toggleParticles()
	if Input.is_action_just_pressed("player_feature_8"):
		isLineTrail = !isLineTrail
	if Input.is_action_just_pressed("player_special_astrix"):
		currentColorWheel += 1
		if currentColorWheel > colorWheel.size()-1:
			currentColorWheel = 0
		#print('colorwheel:'+str(currentColorWheel)+'/'+str(colorWheel.size()))
	if Input.get_action_strength("player_special_5") > 0:
		#if rand_range(1,10) > 5:
		generateLasers()
	update()
	
func setArcCoolDown():
	arcCoolDown = (10+playerNumber*2) - clamp(int((Engine.get_frames_per_second()/60)*10),0,10)
func odds():
	if fpsodds == 1:
		fpsodds = 2
		isShooting = false
	else:
		fpsodds =1
		
func setHeartCoolDown():
	heartCoolDown = 20 - clamp(int((Engine.get_frames_per_second()/60)*10),0,10)

func specialEffectGenerator(type,spin=false,spinrate=1.0,mode='expand'):
	if arcCoolDown < 0 :
			arcCoolDown = 0
	if arcCoolDown == 0 && mode=='expand':
		if !Input.is_action_pressed("Reset_Texture_Fill"):
			Input.action_press("Reset_Texture_Fill")
		get_parent().shakeScreen(rand_range(4,10))
		setArcCoolDown()
		var e = effects_container.get_child(currentEffect)
		e.setColor(getNextColorInArray())
		e.activate(type,spin,spinrate,mode)
		currentEffect = currentEffect + 1
		if currentEffect > effects_container.get_child_count()-1:
			currentEffect = 0
	if mode=='explode':
		var e = effects_container.get_child(currentEffect)
		e.setColor(getNextColorInArray())
		e.activate(type,spin,spinrate,mode)
		currentEffect = currentEffect + 1
		if currentEffect > effects_container.get_child_count()-1:
			currentEffect = 0
	if mode=='random':
		var maxEffects = clamp(int((Engine.get_frames_per_second()/60)*15),2,15)
		for __ in range(maxEffects): #rand_range(5,maxEffects)
			var e = effects_container.get_child(currentEffect)
			e.setColor(getNextColorInArray(true))
			e.activate(type,spin,spinrate,mode)
			currentEffect = currentEffect + 1
			if currentEffect > effects_container.get_child_count()-1:
				currentEffect = 0
#func _draw():
#	if Input.get_action_strength("player_special_5") > 0:
#		if rand_range(1,10)>5: #playerNumber == fpsodds:
#			generateLasers():
			#var points = clamp((Engine.get_frames_per_second()/60)*24,6,48)
			#draw_plus(global_position-position,250,points,getNextColorInArray(rand_range(0,10)>7))
		#odds()		
func draw_line_effect(center,radius,radiusRate,maxPoints,minPoints,color,lineWidth=3,rotateRate=1,rotationOffset=0):
	var isAntialiased = (Engine.get_frames_per_second()>45)
	var isDuo = radiusRate>0
	var points = maxPoints
	if maxPoints != minPoints:
		points = clamp(int((Engine.get_frames_per_second()/60)*maxPoints),minPoints,maxPoints)
	var linePoints = PoolVector2Array()	
	var linePointsDuo = PoolVector2Array()
	var segemntAngle = 360/points
	
	for i in range(points+1):
		var angle_point = deg2rad(segemntAngle*i)
		linePoints.push_back((center + Vector2(cos(angle_point), sin(angle_point)) * radius).rotated(deg2rad(rotationOffset) + global_rotation*rotateRate -deg2rad(90)))
		if isDuo:
			linePointsDuo.push_back((center + Vector2(cos(angle_point), sin(angle_point)) * radius*radiusRate).rotated(deg2rad(rotationOffset)+deg2rad(segemntAngle/2) + global_rotation*rotateRate -deg2rad(90)))
	for point_index in range(linePoints.size()-1):
		if isDuo:
			draw_line(linePoints[point_index], linePointsDuo[point_index], color,lineWidth,isAntialiased)
			draw_line(linePointsDuo[point_index], linePoints[point_index+1], color,lineWidth,isAntialiased)
		else:
			draw_line(linePoints[point_index], linePoints[point_index+1], color,lineWidth,isAntialiased)
	#close shape
	if isDuo:
		draw_line(linePoints[linePoints.size()-1], linePointsDuo[linePoints.size()-1], color,lineWidth,isAntialiased)
		draw_line(linePointsDuo[linePoints.size()-1], linePoints[0], color,lineWidth,isAntialiased)
	else:
		draw_line(linePoints[linePoints.size()-1], linePoints[0], color,lineWidth,isAntialiased)
	
func old_draw_line_effect(center,radius,radiusRate,maxPoints,minPoints,color,lineWidth=3,rotateRate=1,rotationOffset=0):
	var isAntialiased = (Engine.get_frames_per_second()>45)
	var points = maxPoints
	if maxPoints != minPoints:
		points = clamp(int((Engine.get_frames_per_second()/60)*maxPoints),minPoints,maxPoints)
	var linePoints = PoolVector2Array()	
	
	for i in range(points):
		var angle_point = deg2rad((360/points)*i)
		linePoints.push_back((center + Vector2(cos(angle_point), sin(angle_point)) * radius).rotated(deg2rad(rotationOffset) + global_rotation*rotateRate -deg2rad(90)))
		
	for point_index in range(points-1):
		draw_line(linePoints[point_index], linePoints[point_index+1], color,lineWidth,isAntialiased)
	#close shape
	draw_line(linePoints[linePoints.size()-1], linePoints[0], color,lineWidth,isAntialiased)
	
	
func draw_plus(center,radius,points,color):
	radius = int(radius*2) * 6 #*(2.6-scale.x)
	for point in range(points):
		#var angle_point = deg2rad(((360/points)*point)+((360/fpsodds)/points))
		add_Laser_Line_Effect((360/points)*point)
		#points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
		#draw_line(center,Vector2(cos(angle_point), sin(angle_point)) * radius,color,3,false)
func generateLasers():
	var totalPoints=int(Engine.get_frames_per_second()/60 * 36)
	for point in range(totalPoints):
		add_Laser_Line_Effect((360/totalPoints)*point)

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 4 + clamp((Engine.get_frames_per_second()/60)*16,0,64)
	var antiAlias_ring = nb_points<32
	var points_arc = PoolVector2Array()	
	for i in range(nb_points + 2):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
		#points_arc2.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * (radius+3))
		#points_arc3.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * (radius+5))
		
	for index_point in range(nb_points+1):
		draw_line(points_arc[index_point], points_arc[index_point+1], color,3,antiAlias_ring)
		#draw_line(points_arc2[index_point], points_arc2[index_point+1], Color(1,1,1),3,antiAlias_ring)
		#draw_line(points_arc3[index_point], points_arc3[index_point+1], color,2,antiAlias_ring)

func playerMovement(delta):
	#speed = Vector2(100.0,100.0)
	if Input.is_action_just_pressed("Q"):
		position.x = screen_size.x * 0.5
		position.y = screen_size.y * 0.5
	if Input.is_action_just_pressed("player_special_dot"):
		if playerNumber == 1:
			position.x = screen_size.x * 0.25
			position.y = screen_size.y * 0.5
		if playerNumber == 2:
			position.x = screen_size.x * 0.75
			position.y = screen_size.y * 0.5
	if Input.is_action_just_pressed("player_boost"):
		speed.x += 100
		speed.y = speed.x
		if speed.x > 2000:
			speed = Vector2(baseSpeed,baseSpeed)
	if Input.is_action_just_pressed("player_control_mode"):
		if playerNumber == 2:
			if isReverse :
				isReverse = !isReverse
				#position.x = screen_size.x * 0.5
				#position.y = screen_size.y * 0.5
				#get_node("../player").position.x = position.x
				#get_node("../player").position.y = position.y
			else:
				isReverse = !isReverse
				#position.x = screen_size.x * 0.75
				#position.y = screen_size.y * 0.5
				#get_node("../player").position.x = screen_size.x * 0.25
				#get_node("../player").position.y = screen_size.y * 0.5
		
	if(mouse_position != get_local_mouse_position()):
		mouse_position = get_local_mouse_position()
		isMouseMoving = true
	else:
		isMouseMoving = false
	
	if isMouseMoving:
		#rotation += mouse_position.angle()
		pass
	else:
		#rotation += 360*delta
		pass
		
	rotation += 360*delta
	if playerNumber == 2:
		pass
		if isReverse :
			position.x = screen_size.x - get_node("../player").position.x
			position.y = screen_size.y - get_node("../player").position.y
			isMoving = get_node("../player").isMoving
		else:
			direction = get_direction()
			isMoving = direction.x != 0 || direction.y != 0
			if isMoving == false:
				if get_node("../player").isMoving :
					direction.x = get_node("../player").direction.x
					direction.y = get_node("../player").direction.y
			velocity = speed * direction.normalized()
			position += velocity*delta
			#position.x = get_node("../player").position.x
			#position.y = get_node("../player").position.y
			#isMoving = get_node("../player").isMoving
			
	else:
		direction = get_direction()
		isMoving = direction.x != 0 || direction.y != 0
		velocity = speed * direction.normalized()
		position += velocity*delta
	if isMoving:
		get_node("ParticlesEmitter").setEmitters(maxParticle)
	else:
		get_node("ParticlesEmitter").setEmitters(0)
		
func get_direction()->Vector2:
	if isReverse :
		return Vector2(
			Input.get_action_strength("play_one_left")-Input.get_action_strength("play_one_right"),
			Input.get_action_strength("play_one_up")-Input.get_action_strength("play_one_down")
		)
	else:
		if playerNumber == 1:
			return Vector2(
				Input.get_action_strength("play_one_right")-Input.get_action_strength("play_one_left"),
				Input.get_action_strength("play_one_down")-Input.get_action_strength("play_one_up")
			)
		elif playerNumber == 2:
			return Vector2(
				Input.get_action_strength("play_two_right")-Input.get_action_strength("play_two_left"),
				Input.get_action_strength("play_two_down")-Input.get_action_strength("play_two_up")
			)
		else:
			return Vector2.ZERO

func warpWalls(delta):
	#stop if you touch the walls
	#what about spwan on otherside 
	if canWallWarp:
		if position.x < 0:
			position.x = screen_size.x+1
		elif position.x > screen_size.x:
			position.x = 1
		
		if position.y < 0:
			position.y = screen_size.y+1
		elif position.y > screen_size.y:
			position.y = 1
		
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)	

func shoot_classic():
	#rateOfFire.start()
	for __ in range(1):
		if isShooting:
			var b = bullet.instance()
			b.damage = playerLevel*5+baseDamage
			var newScale = 0.1 + int(playerLevel) *0.02
			if newScale > maxBulletScale :
				b.damage += int((playerLevel - int(maxBulletScale/0.02))*10)
				newScale = maxBulletScale
			b.scale = Vector2(newScale,newScale)
			#b.setColor(playerColor)
			b.setTexture(playerTexture)
			bullet_container.add_child(b)
			b.start_at(rotation,get_node("ParticleGun").global_position,__*4,self)
	isShooting = false
	#x1 = x + cos(ang) * distance;
    #y1 = y + sin(ang) * distance;
func setRapidFire():
	rapidFireCount = 6 - clamp(int((Engine.get_frames_per_second()/60) *6),0,6)
func shoot(reverse=false):
	#rateOfFire.start()
	if rapidFireCount > 0:
		isShooting = false
		return
	setRapidFire()
	isShooting = true
	for __ in range(1):
		var b = bullet_container.get_child(currentBullet)
		b.damage = playerLevel*5+baseDamage
		b.isBullet = true
		var newScale = 0.1 + int(playerLevel) *0.02
		if newScale > maxBulletScale :
			b.damage += int((playerLevel - int(maxBulletScale/0.02))*10)
			newScale = maxBulletScale
		b.scale = Vector2(newScale,newScale)
		b.setColor(currentColor)
		#b.setTexture(playerTexture)
		#bullet_container.add_child(b)
		if reverse:
			b.start_at(rotation,get_node("ParticleGun").global_position,__*4,self)
		else:
			b.start_at((rotation-deg2rad(180)),get_node("ParticleGun").global_position,__*4,self)
		currentBullet = currentBullet + 1
		if currentBullet > bullet_container.get_child_count()-1:
			currentBullet = 0
	isShooting = false

func shoot_mid():
	if rapidFireCount > 0:
		isShooting = false
		return
	setRapidFire()
	isShooting = true
	for __ in range(1):
		var b = bullet_container.get_child(currentBullet)
		b.damage = playerLevel*5+baseDamage
		b.isBullet = true
		var newScale = 0.1 + int(playerLevel) *0.02
		if newScale > maxBulletScale :
			b.damage += int((playerLevel - int(maxBulletScale/0.02))*10)
			newScale = maxBulletScale
		b.scale = Vector2(newScale,newScale)
		b.setColor(playerColor)
		#b.setTexture(playerTexture)
		#bullet_container.add_child(b)
		#b.start_at(get_angle_to(screen_center) ,global_position,__*4,self)
		b.start_at((rotation-deg2rad(180)),get_node("ParticleGun").global_position,__*4,self)
		currentBullet = currentBullet + 1
		if currentBullet > bullet_container.get_child_count()-1:
			currentBullet = 0
	isShooting = false		
			
func shoot_spiral():
	 #int(rand_range(0,360)) #clamp(spiralRotation+10,0,360)
	#spinners #= 
	var bulletDirection = 0
	var currentRotation = rotation + spiralRotation
	#var bulletCount = 4+int(28*clamp(Engine.get_frames_per_second()/60,0.0,2.0)
	var scaleMode = 2.5/scale.x
	var bulletCount = clamp(int(Engine.get_frames_per_second()/10)*6*scaleMode,9,int(36*scaleMode))
	isSpecialShooting = true
	for __ in range(bulletCount):
		showInfo('spining=> ' + str(bulletCount),'web')
		if isSpecialShooting:
			bulletDirection = currentRotation + (__ * (360/bulletCount))
			var b = bullet_container.get_child(currentBullet)
			if !b.isBullet: # || b.isBullet:
				#b.damage = playerLevel*5+baseDamage
				var newScale = 0.1 + int(playerLevel) *0.065
				if newScale > maxBulletScale :
					#b.damage += int((playerLevel - int(maxBulletScale/0.02))*10)
					newScale = maxBulletScale
				b.scale = Vector2(newScale,newScale)
				b.setColor(getNextColorInArray())
				b.start_at(bulletDirection,global_position,0,self)
			currentBullet = currentBullet + 1
			if currentBullet > bullet_container.get_child_count()-1:
				currentBullet = 0
			#bullet_container.add_child(b)
	isSpecialShooting = false
	#x1 = x + cos(ang) * distance;
    #y1 = y + sin(ang) * distance;

func add_Laser_Line_Effect(initialAngle = 0):
	var l = laser_line_effect_container.get_child(currentLaserLineEffect)
	if l:
		l.setColor(getNextColorInArray(rand_range(1,10)>8))
		l.activate(initialAngle)
		currentLaserLineEffect += 1
		if currentLaserLineEffect > laser_line_effect_container.get_child_count()-1:
			currentLaserLineEffect = 0
			
func add_Line_Effect(effect):
	var l = line_effect_container.get_child(currentLineEffect)
	if l:
		l.activate(effect)
		currentLineEffect += 1
		if currentLineEffect > line_effect_container.get_child_count()-1:
			currentLineEffect = 0
	
	
	
	
	
	