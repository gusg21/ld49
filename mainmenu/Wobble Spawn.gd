extends Node2D

export(PackedScene) var wobble_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _on_Timer_timeout():
	var wobble = wobble_scene.instance()
	
	wobble.global_position = global_position
	
	get_parent().add_child(wobble)
