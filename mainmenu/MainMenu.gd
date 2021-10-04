extends Node2D

export(Array) var selectors
export(Texture) var controller_icon
export(Texture) var kb_icon
var select_origin : Vector2
var index : int

func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	
	$BGM.play(Globals.MUSIC_TIMECODE)
	select_origin = $Camera/Select.position
	
	Globals.CONTROLLER_MODE = false

func is_gamepad():
	return Input.get_joy_name(0) != ""

func _on_joy_connection_changed(device_id, connected):
	Globals.CONTROLLER_MODE = false

func choose(arr : Array):
	return arr[floor(rand_range(0, arr.size()))]

func update_cursor():
	$Camera/Select.position = select_origin + Vector2(0, 15) * index

func random_texture():
	$Camera/Select.texture = choose(selectors)

func select():
	if index == 0:
		get_tree().change_scene("res://main/Main.tscn")
		Globals.START_TIME = OS.get_unix_time()
	elif index == 1:
		get_tree().change_scene("res://credits/Credits.tscn")
		Globals.MUSIC_TIMECODE = $BGM.get_playback_position()
	elif index == 2:
		get_tree().quit()

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		if index == 0:
			set_process(false)
			$BGM.stop()
			$Timer.start()
			$Confirm.play()
			
			$Tween.interpolate_property($Camera/Play, "rect_position", $Camera/Play.rect_position, $Camera/Play.rect_position + Vector2(500, 0), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0)
			$Tween.start()
		else:
			select()
	
	if Input.is_action_just_pressed("ui_down"):
		index += 1
		$Select.play()
		random_texture()
	if Input.is_action_just_pressed("ui_up"):
		index -= 1
		$Select.play()
		random_texture()
	
	index = index % 3
	if index == -1:
		index = 2
	
	update_cursor()
	
	if Globals.CONTROLLER_MODE:
		$Camera/InputInd.texture = controller_icon
	else:
		$Camera/InputInd.texture = kb_icon


func _on_Timer_timeout():
	select()
