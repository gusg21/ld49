extends AnimatedSprite

func _ready():
	speed_scale = rand_range(0.9, 1.1)
	frame = 1 if randf() > 0.5 else 0
