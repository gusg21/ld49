extends Node2D

var text : Array = [
	["LEVEL DESIGN", "Braeden and Angus"],
	["MUSIC", "Braeden and Angus"],
	["CODE", "Angus and Braeden"],
	["GRAPHICS", "Braeden and Angus"],
	["HELLA CHIVES", "Annie"],
	["FONT", "Angus and Braeden"],
	["TASTY BREATHING", "Braeden and Angus"],
	["MECHANIC DESIGN", "Braeden and Angus"],
	["", "and Grace"],
	["MADE WITH", "Godot, Aseprite and FL Studio"],
	["THANKS TO", "James, Alex, Aidan, and Jon"],
	["THANK YOU FOR PLAYING!", "LD49 (c) 2021"],
]

var time = 0
var index = 0

func _ready():
	if Globals.GAME_DONE:
		$VoopVoop.play()
		Globals.MUSIC_TIMECODE = 0
	else:
		$BGM.play(Globals.MUSIC_TIMECODE)

func _process(delta):
	time += delta
	$Text.bbcode_text = "[center][b]" + text[index][0] + "[/b]\n" + text[index][1]
	$Text.modulate.a = min(time, 1)
	
	if time > 5:
		time = 0
		index += 1
		
		if index == len(text):
			Globals.MUSIC_TIMECODE = $BGM.get_playback_position()
			
			if !Globals.GAME_DONE:
				get_tree().change_scene("res://mainmenu/MainMenu.tscn")
			else:
				get_tree().quit()
