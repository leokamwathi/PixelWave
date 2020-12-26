extends Particles2D
var emitCheck = 100
var oldAmount = 0
var autoParticle = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#modulate = get_parent().get_node("texture").modulate
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func _physics_process(delta):
	return
	if(get_parent().isActive):
		if(!emitting):
			emitting = true
		lifetime = 0.5
	else:
		emitting = false
		lifetime = 0.0
	pass

