extends Node2D

var time = 0
var sound_played : bool = false

func _process(delta):
	time += delta
	
	$Logo.modulate.a = 20 - time * 5
	
	if time > 1 and not sound_played:
		$Sound.play()
		sound_played = true
	
	if time > 5:
		get_tree().change_scene("res://mainmenu/MainMenu.tscn")
