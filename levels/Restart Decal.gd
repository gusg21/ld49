extends Sprite

export(Texture) var controller_decal
export(Texture) var keyboard_decal

func _ready():
	if Globals.CONTROLLER_MODE:
		texture = controller_decal
	else:
		texture = keyboard_decal
