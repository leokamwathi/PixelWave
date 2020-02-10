extends Node2D
onready var bar = get_node("Bar")
onready var barColor = get_node("Bar/CurrentBar")
onready var barBack = get_node("BarBack")

func setColor(newColor):
	barColor.set_modulate(newColor)
func setPower(percentage):
	percentage = clamp(percentage,0,100)
	bar.scale.x = 0.01+(percentage/5)
	bar.position.x = 2*(bar.scale.x)-6
func setBack(percentage):
	percentage = clamp(percentage,0,100)
	barBack.scale.x = 0.01+percentage/5
	barBack.position.x = 2*(barBack.scale.x)-6
func _ready():
	setBack(100)
	setPower(30)