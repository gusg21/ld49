extends StaticBody2D

export(bool) var sound = true
export(float) var delay = 0
export(bool) var up = false
var og_pos : Vector2
var extending : bool = false

func _ready():
	og_pos = position
	if delay == 0:
		$Stab.start()
	else:
		$"Stab Pre-delay".wait_time = delay
		$"Stab Pre-delay".start()

func _process(delta):
	if extending: # extend
		position.y += delta * 250 * (-1 if up else 1)
		if !up:
			if position.y > og_pos.y + 32:
				extending = false
				if is_instance_valid(Globals.CAMERA):
					Globals.CAMERA.shake(0.3, 10)
				if sound:
					$Ground.play()
		else:
			if position.y < og_pos.y - 32:
				extending = false
				if is_instance_valid(Globals.CAMERA):
					Globals.CAMERA.shake(0.3, 10)
				if sound:
					$Ground.play()
	
	# retract
	if up:
		if !extending and position.y < og_pos.y: 
			position.y += delta * 40
	else:
		if !extending and position.y > og_pos.y: 
			position.y -= delta * 40

func _on_Stab_timeout():
	extending = true

func _on_MovingSpike_body_entered(body):
	if body.has_method("destroy"):
		body.destroy()

func _on_Stab_Predelay_timeout():
	$Stab.start()
