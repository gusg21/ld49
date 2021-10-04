extends Camera2D

var shake_time = 0
var SCALE = 5
var lens_cover

func _ready():
	lens_cover = $"Lens Cover"
	$"Lens Cover".hide()
	Globals.CAMERA = self

func shake(time, scale = 5):
	shake_time = time
	SCALE = scale
	
func set_lens_a(a):
	lens_cover.modulate.a = a

func _process(delta):
	print(lens_cover.modulate.a)
	shake_time -= delta
	if shake_time < 0:
		shake_time = 0
		
	offset = Vector2(
		rand_range(-shake_time * SCALE, shake_time * SCALE),
		rand_range(-shake_time * SCALE, shake_time * SCALE)
	)
