extends Node2D

@export var scroll_speed: float = 0.25  # adjust as needed

var world_speed := 0.0
var texture_width := 0
var sprite_a
var sprite_b
var sprite_c

func _ready():
	sprite_a = $SpriteA
	sprite_b = $SpriteB
	sprite_c = $SpriteC
	

func _process(delta):
	sprite_a.position.x -= world_speed * delta * scroll_speed
	sprite_b.position.x -= world_speed * delta * scroll_speed
	sprite_c.position.x -= world_speed * delta * scroll_speed

	# When a background moves completely off-screen, reposition it
	texture_width = sprite_a.texture.get_width() * sprite_a.scale.x
	if sprite_a.position.x <= -texture_width:
		sprite_a.position.x = sprite_c.position.x + texture_width
	if sprite_b.position.x <= -texture_width:
		sprite_b.position.x = sprite_a.position.x + texture_width
	if sprite_c.position.x <= -texture_width:
		sprite_c.position.x = sprite_b.position.x + texture_width
