extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PauseScreen.visible = false
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("Pause"):
		get_tree().paused = !get_tree().paused 
		$PauseScreen.visible = get_tree().paused 

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		pass
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		get_tree().paused = true
		$PauseScreen.visible = get_tree().paused 
