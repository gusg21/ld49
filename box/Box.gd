extends RigidBody2D

class_name Box

enum BOX_COLOR {
	WHITE, PURPLE, GREEN, YELLOW
}
const box_color_colors = {
	BOX_COLOR.WHITE: Color.white,
	BOX_COLOR.PURPLE: Color.blueviolet,
	BOX_COLOR.GREEN: Color.lightgreen,
	BOX_COLOR.YELLOW: Color.yellow,
}

export(BOX_COLOR) var color = BOX_COLOR.WHITE
var dragging : bool = false
var hovered : bool = false
var have_moved : bool = false
var drag_offset : Vector2 = Vector2.ZERO
var last_position : Vector2

func _ready():
	modulate = box_color_colors[color]

func random_color():
	color = BOX_COLOR.values()[rand_range(0, 4)]

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT: # start and stop drag
		if !is_instance_valid(Globals.PLAYER):
			return
		
		dragging = event.pressed
		drag_offset = global_position - get_global_mouse_position()
		if dragging:
			if is_instance_valid(Globals.PLAYER):
				Globals.PLAYER.set_dragging(self)
				$SFX/Dragged.play()
		else:
			if is_instance_valid(Globals.PLAYER):
				Globals.PLAYER.clear_dragging()
				$SFX/Dragged.stop()
				global_position = last_position

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		if !is_instance_valid(Globals.PLAYER):
			return
		
		dragging = false
		if is_instance_valid(Globals.PLAYER):
			Globals.PLAYER.clear_dragging()
			$SFX/Dragged.stop()
			global_position = last_position
		
func _physics_process(delta):
	if is_instance_valid(Globals.PLAYER):
		if Globals.PLAYER.dead:
			dragging = false
	
	mode = RigidBody2D.MODE_STATIC if dragging else RigidBody2D.MODE_RIGID
	if dragging:
		if !have_moved and is_instance_valid(Globals.PLAYER):
			have_moved = true
			Globals.BLOCKS_MOVED += 1
		global_position = get_global_mouse_position() + drag_offset
		rotation_degrees += 1
	if is_instance_valid(Globals.PLAYER):
		if hovered and not dragging and not Globals.PLAYER.dead:
			$GFX.rect_scale = Vector2(1.1, 1.1)
		else:
			$GFX.rect_scale = Vector2.ONE
		
	for body in $Reject.get_overlapping_bodies():
		if dragging and !body.is_in_group("player") and !body.is_in_group("boxes"):
			dragging = false
			if is_instance_valid(Globals.PLAYER):
				Globals.PLAYER.clear_dragging()
			$SFX/Collide.play()
			Globals.CAMERA.shake(0.2)
			global_position += Vector2(0, 0)
			
	last_position = global_position

func get_color():
	return box_color_colors[color]
	
static func get_color_for(color_type):
	return box_color_colors[color_type]
	
static func get_color_int(i):
	var _color
	match i:
		0: _color = BOX_COLOR.WHITE
		1: _color = BOX_COLOR.PURPLE
		2: _color = BOX_COLOR.GREEN
		3: _color = BOX_COLOR.YELLOW
	
	return get_color_for(_color)

func _on_Box_body_entered(body):
#	print("colide " + body.name)
	if !body.is_in_group("player") and not dragging: # hit ground
		$SFX/Landed.play()
		Globals.CAMERA.shake(0.2)
	
	if body.is_in_group("boxes"):
		body = body as Box
		if color != BOX_COLOR.WHITE and color == body.color:
			body.queue_free()
			destroy(global_position.x > body.global_position.x)
		
func destroy(sound = true):
	if is_instance_valid(Globals.PLAYER):
		Globals.PLAYER.clear_dragging()
	
	if is_instance_valid(Globals.CAMERA):
		Globals.CAMERA.shake(0.6, 20)
			
	var explosion = $Explosion.duplicate()
	explosion.global_position = global_position
	explosion.color = get_color()
	get_parent().add_child(explosion)
	explosion.emitting = true
	
	if sound:
		var explode = $SFX/Explode.duplicate()
		get_parent().add_child(explode)
		explode.play()
		
	call_deferred("free")
	
func _on_Box_body_shape_entered(body_id, body, body_shape, local_shape):
	_on_Box_body_entered(body)

func _on_Box_mouse_entered():
	hovered = true

func _on_Box_mouse_exited():
	hovered = false
