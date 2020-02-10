extends Label

var hasText = false
var count = 0
var oldLen = 0

func _physics_process(delta):
	if hasText:
		count -= delta
		if count <= 0:
			set_text('')
			hasText = false
			oldLen = 0
	if get_text().length()>oldLen and !hasText:
		oldLen += get_text().length()
		hasText = true
		count = 3
	

