extends WorldEnvironment

func _physics_process(delta):
	if Input.is_action_just_pressed("player_toggle_glow"):
		environment.glow_enabled = !environment.glow_enabled
	if Input.is_action_just_pressed("player_decrease_glow"):
		environment.glow_intensity-= 0.01
		if environment.glow_intensity < 0:
			environment.glow_intensity = 0
	if Input.is_action_just_pressed("player_increase_glow"):
		environment.glow_intensity+= 0.01
		if environment.glow_intensity > 8:
			environment.glow_intensity = 8
func toggle_glow():
	environment.glow_enabled = !environment.glow_enabled