extends TouchScreenButton

onready var parentNode = get_node('../../../')
var colorChangeCooldown := float(0.0)

func _ready():
	parentNode = get_node('../../../')
	
	
func _physics_process(delta):
	if parentNode.touchMode:
		if colorChangeCooldown <= 0.0:
			modulate = parentNode.getNextColorInArray(rand_range(0,10)>5)
			colorChangeCooldown = 1.0 + rand_range(0.0,1.0)
		else:
			colorChangeCooldown -= delta