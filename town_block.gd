extends Node2D

signal player_entered_town

func _on_area_2d_body_entered(body:Node2D):
    if body.name == "Player":
        emit_signal("player_entered_town")
