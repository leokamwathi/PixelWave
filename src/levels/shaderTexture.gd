extends TextureRect

var iMouse := Vector2.ZERO
var screen := Vector2.ZERO


var mouse_in = false
var dragging = false

onready var shader = get_material()
onready var root = get_owner()

var playerPosition := Vector2.ZERO
	
func _ready():
	screen = get_viewport().get_visible_rect().size	
	#get_material().set_shader_param("screen_size", screen)  # pass screen size on shader script
	set_process(true)
	iMouse.x = rand_range(0,screen.x)
	iMouse.y = rand_range(0,screen.y)
	
func _process(delta):
	if root:
		playerPosition = root.playerPosition
	#make it so that is relates to how clost you are to ther center
	var offSetPosition :=Vector2.ZERO
	offSetPosition.x = int(abs((playerPosition.x/1)-(screen.x/2)))*2
	offSetPosition.y = screen.y - abs(playerPosition.y-screen.y/2)*2
	if self.material:
			if playerPosition:
				self.material.set_shader_param("iMouse",offSetPosition)
				#print("shaderSet",playerPosition)
func _on_Area2D_mouse_entered():
	iMouse = get_global_mouse_position();


func _on_Area2D_mouse_exited():
	iMouse.x = rand_range(0,screen.x)
	iMouse.y = rand_range(0,screen.y)