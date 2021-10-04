extends Area2D

export(NodePath) var bgm_path
#onready var bgm = get_node(bgm_path)

func _on_Spike_body_entered(body):
	if body is Player:
		Globals.PLAYER.kill()

func _on_Timer_timeout():
#	Globals.MUSIC_TIMECODE = bgm.get_playback_position()
	get_tree().reload_current_scene()
