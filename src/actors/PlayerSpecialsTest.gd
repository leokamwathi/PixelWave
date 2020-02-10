extends Node2D


func _physics_process(delta):
	update()
		

func _draw():
	draw_circle(global_position,200,Color(0.5,0.5,0.9))