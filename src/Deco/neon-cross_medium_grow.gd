extends Sprite
var grow_rate := float(0.1)
var spin := false
var spinrate := float(1.0)
var cooldownMode = false
var coolDown = float(2.0)

func _ready():
	visible = false
	cooldownMode = false
	coolDown = 2.0
func setTimeout(amount =0.25):
	cooldownMode = true
	coolDown = rand_range(float(amount/3.0),float(amount))
	
func _physics_process(delta):
	if cooldownMode:
		if coolDown <=0:
			visible= false
			cooldownMode = false
			scale.x = 1.0
			scale.y = 1.0
		else:
			if spin:
				rotation += 1*delta*spinrate
			coolDown -= 1*delta
	else:
		if scale.x < 1.0:
			if grow_rate > 0.0:
				var delsim = float((scale.x) + grow_rate)
				scale.x += delsim*delta
				scale.y += delsim*delta
			if spin:
				rotation += 1*delta*spinrate
		else:
			visible = false