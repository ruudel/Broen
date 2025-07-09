extends Node2D

const GROUND_BLOCK_SCENE = preload("res://ground_block.tscn")
const TOWN_BLOCK_SCENE = preload("res://town_block.tscn")
var speed := 200
var ground_blocks := []
var last_town := 100 # Start far away so first can spawn
const TOWN_MIN_DISTANCE := 10 # Minimum distance between towns (adjust as needed)
const TOWN_CHANCE := 0.15 # 15% chance to spawn a town block
var distance_traveled := -2 # Track total distance traveled, increase every time you spawn a new block

func _ready():
	spawn_ground_block(Vector2(0, 0))

func _process(_delta):
	$Distance.text = "Distance: " + str(distance_traveled)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$StateChart.send_event("player_walking")
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		$StateChart.send_event("camp_entered")
		
func spawn_ground_block(spawn_position: Vector2):
	var block_scene
	# Only spawn a town if far enough from last one and random chance
	if last_town > TOWN_MIN_DISTANCE and randf() < TOWN_CHANCE:
		block_scene = TOWN_BLOCK_SCENE
		last_town = 0 # Reset last town x to allow next town to spawn
	else:
		block_scene = GROUND_BLOCK_SCENE
		last_town += 1

	var block = block_scene.instantiate()
	block.position = spawn_position
	add_child(block)
	ground_blocks.append(block)

	# If it's a town block, connect the signal
	if block_scene == TOWN_BLOCK_SCENE:
		block.connect("player_entered_town", Callable(self, "_on_player_entered_town"))

	# Connect the BlockEndNotifier signal
	block.get_node("BlockEndNotifier").connect("screen_entered", (Callable(self, "_on_groundblock_end_visible").bind(block)))
	distance_traveled += 1

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

func _on_player_entered_town():
	$StateChart.send_event("camp_entered")
