tool

extends Area2D

export(Box.BOX_COLOR) var color setget setter_color, getter_color

func setter_color(v):
	var _color
	match v:
		Box.BOX_COLOR.WHITE: _color = Color.white
		Box.BOX_COLOR.PURPLE: _color = Color.blueviolet
		Box.BOX_COLOR.GREEN: _color = Color.lightgreen
		Box.BOX_COLOR.YELLOW: _color = Color.yellow
	
	modulate = _color
	color = v

func getter_color():
	return color

func _ready():
	modulate = Box.get_color_int(color)
	
func _on_Blocker_area_entered(area):
	var body = area.get_parent()
	
	if body is Box:
		if body.color == color or color == Box.BOX_COLOR.WHITE:
			body.destroy()
