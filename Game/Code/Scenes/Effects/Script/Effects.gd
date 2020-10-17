extends Node

onready var fireworks_container = Node.new()
onready var neoneffects_container = Node.new()
onready var firework = get_node("Firework")
onready var neoneffect = get_node("NeonEffects")



var  isSpecialShooting := bool(false);
var currentFirework := int(0)
var currentEffect := int(0)
var spinner := int(0)


func _ready():
	add_child(fireworks_container)
	add_child(neoneffects_container)
	generate_fireworks()
	generate_neoneffects()

func _physics_process(delta):
	var effect1 = 'expand'
	var effect2 = 'explode'
	var isSpin = false
	var spinRate = 0.0
	
	if Input.is_action_pressed("AltMode"):
		effect1 = 'impand'
		effect2 = 'implode'
	if Input.is_action_pressed("RotateUp"):
		isSpin = true
		spinRate = 5.0
	if Input.is_action_pressed("RotateDown"):
		isSpin = true
		spinRate = -5.0
	if Input.is_action_pressed("Fireworks"):
		do_fireworks()
	if Input.is_action_just_pressed("Num_7"):
		specialEffectGenerator('Triangle',isSpin,spinRate,effect1)
		specialEffectGenerator('Triangle',isSpin,spinRate,effect2)
		specialEffectGenerator('Triangle',false,0.0,'random')
	if Input.is_action_just_pressed("Num_8"):
		specialEffectGenerator('Star',isSpin,spinRate,effect1)
		specialEffectGenerator('Star',isSpin,spinRate,effect2)
		specialEffectGenerator('Star',false,0.0,'random')
	if Input.is_action_just_pressed("Num_4"):
		specialEffectGenerator('Circle',isSpin,spinRate,effect1)
		specialEffectGenerator('Circle',isSpin,spinRate,effect2)
		specialEffectGenerator('Circle',false,0.0,'random')
	if Input.is_action_just_pressed("Num_6"):
		specialEffectGenerator('Diamond',isSpin,spinRate,effect1)
		specialEffectGenerator('Diamond',isSpin,spinRate,effect2)
		specialEffectGenerator('Diamond',false,0.0,'random')
	if Input.is_action_just_pressed("Num_9"):
		specialEffectGenerator('Heart',isSpin,spinRate,effect1)
		specialEffectGenerator('Heart',isSpin,spinRate,effect2)
		specialEffectGenerator('Heart',false,0.0,'random')
	if Input.is_action_just_pressed("Num_5"):
		specialEffectGenerator('Diamond',true,5.0)
		specialEffectGenerator('Diamond',true,5.0,'explode')
		specialEffectGenerator('Diamond',true,5.0,'random')
func generate_fireworks():
	var fireworkStore = 5000
	for __ in range(fireworkStore):
		var f = firework.duplicate()
		f.deactivate()
		fireworks_container.add_child(f)
func generate_neoneffects():
	var effectStore = 400
	for __ in range(effectStore):
		var e = neoneffect.duplicate()
		#l.setTexture(playerTexture)
		e.deactivate()
		#e.setParent(get_parent())
		neoneffects_container.add_child(e)
func _input(event):
	if event.is_action_pressed("Fireworks"):
		pass
		do_fireworks()
	
		
func do_fireworks():
	 #int(rand_range(0,360)) #clamp(spiralRotation+10,0,360)
	#spinners #= 
	if isSpecialShooting:
		return
	var fireworkDirection = 0
	var currentRotation = 0
	#var bulletCount = 4+int(28*clamp(Engine.get_frames_per_second()/60,0.0,2.0)
	var scaleMode = 1
	var bulletCount = clamp(int(Engine.get_frames_per_second()/10)*6*scaleMode,9,int(36*scaleMode))
	isSpecialShooting = true
	for __ in range(bulletCount):
		fireworkDirection = spinner + (__ * (360/bulletCount))
		var f = fireworks_container.get_child(currentFirework)
		if !f.isExploding: # || b.isBullet:
			f.scale = Vector2(1,1)
			f.setColor(get_parent().get_node("ColorArray").getNextColorInArray(true))
			f.start_at(fireworkDirection,get_viewport().size/2 ,0,self)
		currentFirework = currentFirework + 1
		if currentFirework > fireworks_container.get_child_count()-1:
			currentFirework = 0
		spinner += 1
		if spinner> 360:
			spinner = 0

	isSpecialShooting = false
	#x1 = x + cos(ang) * distance;
	#y1 = y + sin(ang) * distance;
func specialEffectGenerator(type,spin=false,spinrate=1.0,mode='expand'):
	#if arcCoolDown < 0 :
	#		arcCoolDown = 0
	if mode=='expand':
		#get_parent().shakeScreen(rand_range(4,10))
		#setArcCoolDown()
		var e = neoneffects_container.get_child(currentEffect)
		e.setColor(get_parent().get_node("ColorArray").getNextColorInArray(true))
		e.activate(type,spin,spinrate,mode)
		currentEffect = currentEffect + 1
		if currentEffect > neoneffects_container.get_child_count()-1:
			currentEffect = 0
	if mode=='impand':
		#get_parent().shakeScreen(rand_range(4,10))
		#setArcCoolDown()
		var e = neoneffects_container.get_child(currentEffect)
		e.setColor(get_parent().get_node("ColorArray").getNextColorInArray(true))
		e.activate(type,spin,spinrate,mode)
		currentEffect = currentEffect + 1
		if currentEffect > neoneffects_container.get_child_count()-1:
			currentEffect = 0
	if mode=='explode':
		var e = neoneffects_container.get_child(currentEffect)
		e.setColor(get_parent().get_node("ColorArray").getNextColorInArray(true))
		e.activate(type,spin,spinrate,mode)
		currentEffect = currentEffect + 1
		if currentEffect > neoneffects_container.get_child_count()-1:
			currentEffect = 0
	if mode=='random':
		var maxEffects = clamp(int((Engine.get_frames_per_second()/60)*15),2,15)
		for __ in range(maxEffects): #rand_range(5,maxEffects)
			var e = neoneffects_container.get_child(currentEffect)
			e.setColor(get_parent().get_node("ColorArray").getNextColorInArray(true))
			e.activate(type,spin,spinrate,mode)
			currentEffect = currentEffect + 1
			if currentEffect > neoneffects_container.get_child_count()-1:
				currentEffect = 0
	if mode=='implode':
		#get_parent().shakeScreen(rand_range(4,10))
		#setArcCoolDown()
		var e = neoneffects_container.get_child(currentEffect)
		e.setColor(get_parent().get_node("ColorArray").getNextColorInArray(true))
		e.activate(type,spin,spinrate,mode)
		currentEffect = currentEffect + 1
		if currentEffect > neoneffects_container.get_child_count()-1:
			currentEffect = 0
	
