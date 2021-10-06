extends Node2D

var time = 0
var sound_played : bool = false

func _physics_process(delta):
	time += delta
	
	var new_a = 20 - time * 5
	$Logo.modulate.a = new_a
	$"Audio Warning".modulate.a = new_a
	
	if time > 1 and not sound_played:
		$Sound.play()
		sound_played = true
	
	if time > 5:
		get_tree().change_scene("res://mainmenu/MainMenu.tscn")
