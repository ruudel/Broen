extends Label

var padding = 16

func _ready():
	call_deferred("update_position")

func update_position():
	var screen_size = get_viewport_rect().size  # FIXED
	var label_size = get_minimum_size()         # Label's own size

	# Center horizontally, 16px from the top
	position = Vector2((screen_size.x - label_size.x) / 2, 16)

	# Position decorative sprites if present
	$LabelLeft.position = Vector2(-$LabelLeft.texture.get_size().x - padding, 0)
	$LabelRight.position = Vector2(label_size.x + padding, 0)
