extends WorldEnvironment


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("Glow"):
		environment.glow_intensity += 0.1;
		if environment.glow_intensity > 1.0:
			environment.glow_intensity  = 0
			environment.glow_enabled = false
		if environment.glow_intensity  >0:
			environment.glow_enabled  = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
