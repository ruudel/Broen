extends Node2D

@export var town_name:String

signal player_entered_town

func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Player":
		#emit_signal("player_entered_town")
		player_entered_town.emit(town_name)
