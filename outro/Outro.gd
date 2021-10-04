extends Node2D

var can_credits = false

func get_time():
	var time = OS.get_unix_time() - Globals.START_TIME
	return str(floor(time / 60)) + ":" + str(time % 60).pad_zeros(2)

func _ready():
	Globals.GAME_DONE = true
	
	$Label.modulate = Color.transparent
	$Animation.modulate = Color.transparent
	$Fade.show()
	
	$Tween.interpolate_property($Fade, "modulate", Color.black, Color.transparent, 4)
	$Tween.interpolate_property(
		$Animation, "modulate", Color.transparent, Color.white, 
		2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 4
	)
	$Tween.interpolate_property($Noise, "volume_db", -80, 10, 2, Tween.TRANS_EXPO, Tween.EASE_IN, 4)
	$Tween.interpolate_property($Animation, "position", Vector2.ZERO, $Animation.position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 10)
	$Tween.interpolate_property($Label, "modulate", Color.transparent, Color.white, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 10)

	$Animation.position = Vector2.ZERO

	$Tween.start()

	$Label.bbcode_text = "[center][color=black][shake][b][color=red]TIME:[/color][/b] " + get_time() + \
						"\n\n[b][color=red]BOXES MOVED:[/color][/b] " + str(Globals.BLOCKS_MOVED) + \
						"\n\n[b][color=red]TIMES DIED:[/color][/b] " + str(Globals.DEATHS) + \
						"\n\nANY KEY FOR CREDITS"

func _input(event):
	if event is InputEventKey:
		if event.pressed and can_credits:
			get_tree().change_scene("res://credits/Credits.tscn")

func _on_Tween_tween_all_completed():
	can_credits = true
