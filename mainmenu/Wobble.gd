extends KinematicBody2D

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity = Vector2(-160, 0)
	$GFX.rotation_degrees += delta * 180
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.78, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("boxes"):
			collision.collider.apply_central_impulse(-collision.normal * velocity.length() * 20)
