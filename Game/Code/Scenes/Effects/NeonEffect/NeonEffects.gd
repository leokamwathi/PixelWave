extends Node2D

var screen_size = Vector2.ZERO
var expand = false
var explode = false
var impand = false
var implode = false
var random = false
var active = false
var looper = false
var baseScale = 0.05

onready var neon_texture = get_node('Neon_Texture')
onready var neon_texture_fill = get_node('Neon_Texture_Fill')
onready var neon_beam = get_node('Neon_Beam')
#onready var playerNode = get_parent().get_parent()

export var neon_color:= Color(0.0,0.0,0.0)

export var effectTexture := []
export var effectTextureFill := []
export var effectBeam := []
export var effectNames := ['Triangle']

var showFill = true
var fillCoolDown = 2

func _ready():
	neon_texture = get_node('Neon_Texture')
	neon_texture_fill = get_node('Neon_Texture_Fill')
	neon_beam = get_node('Neon_Beam')
	#screen_size = get_viewport_rect().size
	neon_texture.visible = false
	neon_texture_fill.visible = false
	neon_beam.visible = false
	visible = false
	active = false
	#position = playerNode.global_position
	#pass
	
func _physics_process(delta):
	if !random:
		position = get_viewport_rect().size/2
	if (neon_texture):
		#neon_texture.grow_rate = float(playerNode.scale.x*0.3) + 0.1
		#neon_beam.grow_rate = neon_texture.grow_rate
		if looper && !random && active && Input.is_action_pressed("Reset_Texture_Fill"):
			showFill = false
			looper = false
			fillCoolDown = 0
			#print('Action PRESSED')
		if showFill && neon_texture_fill.visible:
			if fillCoolDown <= 0:
				looper = false
				showFill = false
			elif fillCoolDown >= 0:
				if fillCoolDown <= 0.75:	
					looper = true
				fillCoolDown -= 2*delta
		else:
			neon_texture_fill.visible = false
			if random:
				deactivate()
	if neon_texture.visible == false && active:
		neon_texture_fill.visible = false
		neon_beam.visible = false
		neon_texture.visible = false
		deactivate()
	#pass
func setColor(color):
	if (neon_texture):
		neon_texture.modulate = color
		neon_texture_fill.modulate = color
		neon_beam.modulate = color

func activate(type,spin=false,spinrate=0,mode='expand'):
	#print(mode)
	modulate = Color(1.0,1.0,1.0,1.0)
	if (neon_texture):
		if mode == 'expand':
			expandMode(type,spin,spinrate)
		if mode == 'impand':
			impandMode(type,spin,spinrate)		
		if mode == 'explode':
			explodeMode(type,spin,spinrate)
		if mode == 'random':
			randomMode(type,spin,spinrate)
		if mode == 'implode':
			implodeMode(type,spin,spinrate)
	active = true
	visible = true
func expandMode(type,spin=false,spinrate=0):
	#print('Expand')
	expand = true
	showFill = true
	fillCoolDown = 1
	var indexOfType = effectNames.find(type)
	if indexOfType >= 0:
		setNeonTextureType(indexOfType)
		setNeonTextureVisible(true)
		setNeonTextureSpin(spin)
		setNeonTextureSpinrate(spinrate)		
		setNeonTextureScale(Vector2(baseScale,baseScale))
		setNeonTextureRotation(deg2rad(0))
		setNeonTextureGrowrate(float(baseScale*0.3) + 0.1)
		neon_texture_fill.spinrate=spinrate * 2.0
		neon_texture_fill.grow_rate = 0.0

	else:
		print('Effect Not found '+type)
func impandMode(type,spin=false,spinrate=0):
	#print('Expand')
	impand = true
	showFill = false
	fillCoolDown = 1
	var indexOfType = effectNames.find(type)
	if indexOfType >= 0:
		setNeonTextureType(indexOfType)
		setNeonTextureVisible(true)
		setNeonTextureSpin(spin)
		setNeonTextureSpinrate(spinrate)		
		setNeonTextureScale(Vector2(baseScale*17.0,baseScale*17.0))
		setNeonTextureRotation(deg2rad(0))
		setNeonTextureGrowrate((float((baseScale/15.0)+0.5))*-1.0)
		neon_texture_fill.spinrate=spinrate * 2.0
		neon_texture_fill.grow_rate = 0.0

	else:
		print('Effect Not found '+type)
func explodeMode(type,spin=false,spinrate=0):
	modulate = Color(1.0,1.0,1.0,0.10)
	#print('Explode')
	explode = true
	showFill = false
	fillCoolDown = 0
	var indexOfType = effectNames.find(type)
	if indexOfType >= 0:
		setNeonTextureType(indexOfType)
		setNeonTextureVisible(true)
		setNeonTextureSpin(spin)
		setNeonTextureSpinrate(spinrate)		
		setNeonTextureScale(Vector2(baseScale,baseScale))
		setNeonTextureRotation(deg2rad(0))
		setNeonTextureGrowrate(2.0 + baseScale + 0.1)
		#float(playerNode.scale.x*0.3) + 0.1
		#setNeonTextureTimeout(0.5)
		
		#leo
		neon_texture_fill.visible = false
		#neon_texture_fill.spinrate=0.0
		#neon_texture_fill.scale = Vector2.ZERO
		#neon_texture_fill.rotation = 0
		#neon_texture_fill.grow_rate = 0.0

	else:
		print('Effect Not found '+type)
func implodeMode(type,spin=false,spinrate=0):
	modulate = Color(1.0,1.0,1.0,0.10)
	#print('Explode')
	implode = true
	showFill = false
	fillCoolDown = 0
	var indexOfType = effectNames.find(type)
	if indexOfType >= 0:
		setNeonTextureType(indexOfType)
		setNeonTextureVisible(true)
		setNeonTextureSpin(spin)
		setNeonTextureSpinrate(spinrate)		
		setNeonTextureScale(Vector2(baseScale*10.0,baseScale*10.0))
		setNeonTextureRotation(deg2rad(0))
		setNeonTextureGrowrate((2.0 + (baseScale/10.0) + 0.1) * -1.0)
		#float(playerNode.scale.x*0.3) + 0.1
		#setNeonTextureTimeout(0.5)
		
		neon_texture_fill.visible = false
		#neon_texture_fill.spinrate=0.0
		#neon_texture_fill.scale = Vector2.ZERO
		#neon_texture_fill.rotation = 0
		#neon_texture_fill.grow_rate = 0.0

	else:
		print('Effect Not found '+type)		
func randomMode(type,spin=false,spinrate=0):
	#print('Explode')
	random = true
	showFill = true
	fillCoolDown = 4 + (10 * spinrate)
	var indexOfType = effectNames.find(type)
	if indexOfType >= 0:
		
		position.x = rand_range(0,get_viewport_rect().size.x)
		position.y = rand_range(0,get_viewport_rect().size.y)
		var baseScale = rand_range(0.005,0.025) #float(playerNode.scale.x/100)*2.0 + 0.02
		
		setNeonTextureType(indexOfType)
		setNeonTextureVisible(true)
		setNeonTextureSpin(spin)
		setNeonTextureSpinrate(spinrate * rand_range(1,2))
		setNeonTextureScale(Vector2(baseScale,baseScale))
		setNeonTextureRotation(deg2rad(0))
		setNeonTextureGrowrate(2.0)
		setNeonTextureTimeout(0.5)
	else:
		print('Effect Not found '+type)
func setNeonTextureType(indexOfType):
	neon_texture.texture = effectTexture[indexOfType]
	neon_texture_fill.texture = effectTextureFill[indexOfType]
	neon_beam.texture = effectBeam[indexOfType]
func setNeonTextureVisible(is_visible):
	neon_texture.visible = is_visible
	neon_texture_fill.visible = is_visible
	neon_beam.visible = is_visible
func setNeonTextureSpin(spin):
	neon_texture.spin = spin
	neon_texture_fill.spin = spin
	neon_beam.spin = spin
func setNeonTextureSpinrate(spinrate):
	neon_texture.spinrate=spinrate
	neon_texture_fill.spinrate = neon_texture.spinrate
	neon_beam.spinrate=neon_texture.spinrate
func setNeonTextureScale(newScale):
	neon_texture.scale = newScale
	neon_texture_fill.scale = newScale
	neon_beam.scale = newScale
func setNeonTextureRotation(rotationRadians):
	neon_texture.rotation = rotationRadians
	neon_texture_fill.rotation = rotationRadians
	neon_beam.rotation = rotationRadians
func setNeonTextureGrowrate(growRate):
	neon_texture.grow_rate = growRate
	neon_texture_fill.grow_rate = growRate
	neon_beam.grow_rate = growRate
func setNeonTextureTimeout(timeout):
	neon_beam.setTimeout(timeout)
	neon_texture.setTimeout(timeout)
	neon_texture_fill.setTimeout(timeout)



func deactivate():
	active = false
	expand = false
	explode = false
	random = false
	showFill = false
	looper = false
	visible = false
	fillCoolDown = 0
	position = get_viewport_rect().size/2
	if (neon_texture):
		neon_texture.visible = false
		neon_texture_fill.visible = false
		neon_beam.visible = false
		neon_texture.scale = Vector2(0.01,0.01)
		neon_texture_fill.scale = Vector2(0.01,0.01)
		neon_beam.scale = Vector2(0.01,0.01)
		neon_texture.rotation = deg2rad(0)
		neon_texture_fill.rotation = deg2rad(0)
		neon_beam.rotation = deg2rad(0)
