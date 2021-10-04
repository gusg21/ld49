extends Area2D

export(PackedScene) var scene

var fade_time = 1.5
var time = 0
var fading = false

func _on_End_Door_body_entered(body):
	if body == Globals.PLAYER:
		if Globals.MAIN.last_level():
			Globals.CAMERA.lens_cover.visible = true
			
			$Tween.interpolate_property(Globals.MAIN.bgm, "volume_db", 0, -80, fade_time, Tween.TRANS_LINEAR)
			$Tween.start()
		else:
			Globals.MAIN.next_level()
			
func _on_Tween_tween_all_completed():
	get_tree().change_scene("res://outro/Outro.tscn")
