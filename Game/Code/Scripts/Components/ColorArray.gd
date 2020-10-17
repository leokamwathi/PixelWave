extends Node
export (Color) var playerColor
export var color_array = [Color(.39,.68,.21),Color(1,1,.32),Color(.98,.6,.07),Color(1,.15,.07),Color(.51,0,.65),Color(.07,.27,.98)]
export var color_array2 = [Color(1,1,1)]
export var color_array3 = [Color(1,1,1)]
export var color_array4 = [Color(1,1,1)]
export var color_array5 = [Color(1,1,1)]
export var color_array6 = [Color(1,1,1)]
export var colorWheel = [[Color(.39,.68,.21),Color(1,1,.32),Color(.98,.6,.07),Color(1,.15,.07),Color(.51,0,.65),Color(.07,.27,.98)],[Color(1,1,1)]]
export var changeSpeed := int(100)

#var colorWheel = []
var color_index = 0
var colorCoolDown = 100
var currentCoolDown = 100
var isColorMixing := true
var currentColorWheel = 0
var currentColor := Color(1.0,1.0,1.0,1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	#colorWheel = [color_array,color_array2,color_array3,color_array3,color_array4,color_array5,color_array6]
	pass # Replace with function body.
func _input(event):
	if event.is_action_pressed("ColorCycle"):
		currentColorWheel += 1
		if currentColorWheel > colorWheel.size() -1:
			currentColorWheel = 0
	
func getNextColorInArray(forceRotate = false):
	#print(currentColorWheel)
	if color_index > colorWheel[currentColorWheel].size()-1:
		color_index = 0
	currentColor = colorWheel[currentColorWheel][color_index]
	
	colorCycle()
	return currentColor
func setSpeed(speed):
	if speed < 100:
		speed = 100
	if speed > 1000:
		speed = 1000
	currentCoolDown = 300 - ((speed/1000)*80)
	colorCoolDown = currentCoolDown
	pass	
func colorCycle():
	if colorCoolDown==0:
		color_index +=1
		colorCoolDown = currentCoolDown
	colorCoolDown -= 1
	if color_index > colorWheel[currentColorWheel].size()-1:
		color_index = 0
