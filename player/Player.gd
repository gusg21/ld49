class_name Player

extends KinematicBody2D

export var move_speed = 100
export var gravity = 10
var velocity:Vector2 = Vector2.ZERO
var dragging : Box = null
var just_landed = false
var dead = false
var coyote_time = 0

func _ready():
	Globals.PLAYER = self
	
func can_jump():
	return $FloorCast.is_colliding() or is_on_floor()

func _physics_process(delta):
	coyote_time += delta
	var raw_x_input = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * move_speed
	
	velocity.x = lerp(velocity.x, raw_x_input, 0.2)
	
	if !is_on_floor():
		velocity.y += gravity
	else:
		if just_landed:
			$Audio/Hit.play()
			just_landed = false
	
	if can_jump():
		coyote_time = 0
		
	if Input.is_action_just_pressed("jump") and (can_jump() or coyote_time < 0.05):
		$Audio/Jump.play()
		velocity.y = -280
		coyote_time = 100
		just_landed = true
	
	var raw_velocity = velocity
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("boxes"):
			collision.collider.apply_central_impulse(-collision.normal * raw_velocity.length() * 0.8)
			
	handle_animations(raw_velocity)
	
	if Input.is_action_just_pressed("restart"):
		kill()

func destroy():
	kill()

func my_disable():
	hide()
	if is_instance_valid(dragging):
		dragging.dragging = false
	clear_dragging()
	set_physics_process(false)
	set_process(false)

func kill():
	$Audio/Die.play()
	$Timer.start()
	var bummer = $BUMMER.duplicate()
	get_parent().add_child(bummer)
	bummer.global_position = global_position
	bummer.emitting = true
	dead = true
	my_disable()
	
	Globals.DEATHS += 1

func set_dragging(obj : CollisionObject2D):
	dragging = obj
	
func clear_dragging():
	dragging = null

func handle_animations(vel : Vector2):
	if abs(vel.x) > 0.1:
		$GFX.frames.set_animation_speed("walk", abs(vel.x))
		$GFX.play("walk")
		
		if vel.x > 0:
			$GFX.flip_h = false
		else:
			$GFX.flip_h = true
	else:
		$GFX.play("idle")
		
	$ControlSpell.emitting = dragging != null
	if dragging != null and is_instance_valid(dragging):
		if !$Audio/Spell.playing:
			$Audio/Spell.play()
		
		$ControlSpell.color = dragging.get_color()
		$ControlSpell.direction = (dragging.global_position - global_position).normalized()
		$ControlSpell.lifetime = (global_position.distance_to(dragging.global_position)) / 300
	else:
		$Audio/Spell.stop()


func _on_Timer_timeout():
	Globals.MAIN.restart()
