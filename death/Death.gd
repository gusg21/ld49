extends Sprite

export(Vector2) var direction

func _physics_process(delta):
	position += direction.normalized() * delta * 10

func _on_Area2D_body_entered(body : Node2D):
	if body.has_method("destroy"):
		body.destroy()
