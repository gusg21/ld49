extends Node2D

export(PackedScene) var box_scene

func _ready():
	pass
	
func _on_Timer_timeout():
	var box = box_scene.instance()
	box.global_position = global_position + Vector2(rand_range(-10, 10), 0)
#	box.rotation_degrees = rand_range(-45, 45)
	box.random_color()
	get_parent().add_child(box)
