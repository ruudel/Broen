extends Node2D

const GROUND_BLOCK_SCENE = preload("res://ground_block.tscn")
const TOWN_BLOCK_SCENE = preload("res://town_block.tscn")
var speed := 100
var ground_blocks := []
var last_town_x := -10000 # Start far away so first can spawn
const TOWN_MIN_DISTANCE := 3000 # Minimum distance between towns (adjust as needed)
const TOWN_CHANCE := 0.15 # 15% chance to spawn a town block

func _ready():
	spawn_ground_block(Vector2(0, 0))

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$StateChart.send_event("player_walking")
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		$StateChart.send_event("player_idle")
		
func spawn_ground_block(spawn_position: Vector2):
	var block_scene
	# Only spawn a town if far enough from last one and random chance
	if spawn_position.x - last_town_x > TOWN_MIN_DISTANCE and randf() < TOWN_CHANCE:
		block_scene = TOWN_BLOCK_SCENE
		last_town_x = spawn_position.x
	else:
		block_scene = GROUND_BLOCK_SCENE

	var block = block_scene.instantiate()
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

func _on_moving_state_processing(delta:float):
	for block in ground_blocks:
		block.position.x -= speed * delta
	
func _on_idle_state_processing(_delta:float):
	pass

func _on_idle_state_entered():
	get_node("Player/StateChart").send_event("to_idle")

func _on_moving_state_entered():
	get_node("Player/StateChart").send_event("to_walk")
