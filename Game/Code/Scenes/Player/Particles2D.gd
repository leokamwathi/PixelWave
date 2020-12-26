extends Particles2D
var emitCheck = 100
var oldAmount = 0
var autoParticle = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	oldAmount = amount
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func _physics_process(delta):
	if(get_parent().get_parent().particleLifeTime > 0):
		emitting = true
		lifetime = get_parent().get_parent().particleLifeTime
	else:
		emitting = false
	modulate = get_parent().get_node("Trail").modulate
	emitCheck -= 100*delta
	if emitting && emitCheck < 0 && autoParticle:
		emitCheck = 100
		var stabilityFactor = Engine.get_frames_per_second()/60.0
		var newAmount = 500 * stabilityFactor
		if (newAmount < (oldAmount*0.9) || newAmount > (oldAmount*1.1) ):
			amount = newAmount
			oldAmount = newAmount
	pass
