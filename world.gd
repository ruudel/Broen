extends Node2D

# Constants
const GROUND_BLOCK_SCENE = preload("res://ground_block.tscn")
const TOWN_BLOCK_SCENE = preload("res://town_block.tscn")
const EVENT_SCENES = [preload("res://events/event_adventurer.tscn"),preload("res://events/event_enemy.tscn")]

const EVENT_CHANCE := 0.2  # % chance to spawn an event
const TOWN_MIN_DISTANCE := 10
const TOWN_CHANCE := 0.35

# Variables
var speed := 600
var ground_blocks: Array = []
var last_town := 0
var distance_traveled := 0
var randSeed: int = 73425  # Set this to whatever you like for consistent worlds
var world_rng := RandomNumberGenerator.new()

# Ready
func _ready():
	spawn_ground_block(Vector2(640, 0))
	ground_blocks.append(get_node("HomeTown"))
	var home = get_node("HomeTown")
	home.town_name = "home"
	home.connect("player_entered_town", Callable(self, "_on_player_entered_town"))


# Process
func _process(_delta):
	$Distance.text = "Distance: " + str(distance_traveled)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$StateChart.send_event("player_walking")
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		$StateChart.send_event("player_stopped")

# Block Spawning (Deterministic)
func spawn_ground_block(spawn_position: Vector2):
	world_rng.seed = randSeed + distance_traveled  # Deterministic per block
	var block_scene = GROUND_BLOCK_SCENE
	
	if last_town > TOWN_MIN_DISTANCE and world_rng.randf() < TOWN_CHANCE:
		block_scene = TOWN_BLOCK_SCENE
		last_town = 0
		
	else:
		last_town += 1

	var block = block_scene.instantiate()
	block.position = spawn_position
	add_child(block)
	ground_blocks.append(block)
	
	# EVENT SPAWNING — Deterministic, per block
	var event_rng = RandomNumberGenerator.new()
	event_rng.seed = randSeed + distance_traveled + 100000  # Separate stream

	if block_scene != TOWN_BLOCK_SCENE:
		if event_rng.randf() < EVENT_CHANCE:
			var event_scene = EVENT_SCENES[event_rng.randi_range(0, EVENT_SCENES.size() - 1)]
			var event_instance = event_scene.instantiate()

			# Position event relative to the block (e.g. somewhere on the ground)
			event_instance.position = Vector2(0, 324)  # Adjust relative offset as needed
			
			if event_instance.has_signal("player_triggered_event"):
				event_instance.connect("player_triggered_event", Callable(self, "_on_player_triggered_event"))
				
			if event_instance.has_signal("player_triggered_enemy"):
				event_instance.connect("player_triggered_enemy", Callable(self, "_on_player_triggered_enemy"))

			block.add_child(event_instance)  # Add to the block so it moves with it

	if block_scene == TOWN_BLOCK_SCENE:
		var name_list = ["Townsville", "Poopholé", "Butt's End", "Tent city", "Loser town"]
		var town_name = name_list[world_rng.randi_range(0, name_list.size() - 1)].to_upper()
		block.town_name = town_name
		block.connect("player_entered_town", Callable(self, "_on_player_entered_town"))

	block.get_node("BlockEndNotifier").connect("screen_entered", Callable(self, "_on_groundblock_end_visible").bind(block))

	distance_traveled += 1

func save_game():
	var save_data = {
		"randSeed": randSeed,
		"distance_traveled": distance_traveled
	}
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return  # No save file yet
	var file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var save_data = JSON.parse_string(file.get_as_text())
	file.close()
	if save_data is Dictionary:
		randSeed = save_data.get("randSeed", randSeed)
		distance_traveled = save_data.get("distance_traveled", 0)

func show_event_popup(text: String):
	$GUI/EventDialog/Label.text = text
	$GUI/EventDialog.visible = true












func _on_groundblock_end_visible(block):
	var tiles = block.get_node("Tiles")
	var width = tiles.get_used_rect().size.x * tiles.tile_set.tile_size.x
	var next_pos = Vector2(block.position.x + width, block.position.y)
	spawn_ground_block(next_pos)

func _on_moving_state_processing(delta: float):
	for block in ground_blocks:
		block.position.x -= speed * delta

func _on_idle_state_processing(_delta: float):
	pass

func _on_idle_state_entered():
	get_node("Player/StateChart").send_event("to_idle")
	
func _on_moving_state_entered():
	get_node("Player/StateChart").send_event("to_walk")
	$GUI/EventDialog.visible = false

func _on_player_entered_town(town_name:String):
	$GUI/TownLabel.text = town_name
	$StateChart.send_event("player_stopped")
	$GUI/FadeTownLabel.play("fade_town_label")
	$GUI/TownLabel.update_position()

func _on_player_triggered_event():
	$StateChart.send_event("player_stopped")
	show_event_popup("Interesting stuff will happen here")

func _on_player_triggered_enemy():
	$StateChart.send_event("player_stopped")
	show_event_popup("Enemy!!!")
