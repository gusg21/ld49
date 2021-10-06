extends Label

func _ready():
	if OS.has_feature('web'):
		visible = true
