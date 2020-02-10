extends Node2D
var lastAmount = 0
var isEmitting = true

func setTexture(tex):
	get_node("0").set_texture(tex)
	get_node("0").set_texture(tex)
	get_node("10").set_texture(tex)
	get_node("20").set_texture(tex)
	get_node("30").set_texture(tex)
	get_node("40").set_texture(tex)
	get_node("50").set_texture(tex)
	get_node("60").set_texture(tex)
	get_node("70").set_texture(tex)
	get_node("80").set_texture(tex)
	get_node("90").set_texture(tex)
	get_node("100").set_texture(tex)
	
func setEmitters(amount):
	lastAmount = amount
	hideAllEmitters()
	if isEmitting:
		get_node("0").set_emitting(true)
		if amount>0:
			get_node("20").set_emitting(true)
		if amount>20:
			get_node("40").set_emitting(true)
		if amount>40:
			get_node("60").set_emitting(true)
		if amount>60:
			get_node("80").set_emitting(true)
		if amount>80:
			get_node("100").set_emitting(true)
		
func hideAllEmitters():
	get_node("0").set_emitting(false)
	get_node("10").set_emitting(false)
	get_node("20").set_emitting(false)
	get_node("30").set_emitting(false)
	get_node("40").set_emitting(false)
	get_node("50").set_emitting(false)
	get_node("60").set_emitting(false)
	get_node("70").set_emitting(false)
	get_node("80").set_emitting(false)
	get_node("90").set_emitting(false)
	get_node("100").set_emitting(false)
	
	#for childIndex in range(get_child_count()):
	#	get_child(childIndex).set_emitting(false)
		
		
		#if get_child(childIndex).get_class() == 'CPUParticles2D':
		


func isEmitters(isVisible):
	isEmitting = isVisible
	#visible = isVisible
	if isVisible:
		#show()
		setEmitters(lastAmount)
	else:
		#hide()
		hideAllEmitters()