extends Node2D

export(Array) var levels
var level_node
var level_num = 0
var bgm

func _ready():
	bgm = $BGM
	Globals.MAIN = self
	next_level()
	
	$BGM.play()
	
func last_level():
	return level_num == len(levels)	

func _process(delta):
	if Input.is_action_just_pressed("next_level"):
		next_level()

func next_level():
	if level_node != null:
		level_node.queue_free()
	
	if !last_level():
		var new_level = levels[level_num].instance()
		add_child(new_level)
		level_node = new_level
		
		level_num += 1

func restart():
	level_num -= 1
	next_level()
