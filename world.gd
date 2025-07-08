extends Node2D

const GROUND_BLOCK_SCENE = preload("res://ground_block.tscn")
var speed := 100
var ground_blocks := []

func _ready():
	spawn_ground_block(Vector2(0, 0))

func _physics_process(delta):
	for block in ground_blocks:
		block.position.x -= speed * delta

func spawn_ground_block(spawn_position: Vector2):
	var block = GROUND_BLOCK_SCENE.instantiate()
	block.position = spawn_position
	add_child(block)
	ground_blocks.append(block)
	# Connect the BlockEndNotifier signal
	block.get_node("BlockEndNotifier").connect("screen_entered", (Callable(self, "_on_groundblock_end_visible").bind(block)))

func _on_groundblock_end_visible(block):
	# Spawn the next block when the end enters the viewport
	var width = block.get_node("GroundTiles").get_used_rect().size.x * block.get_node("GroundTiles").tile_set.tile_size.x
	var next_pos = Vector2(block.position.x + width, block.position.y)
	spawn_ground_block(next_pos)
