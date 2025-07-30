extends StaticBody2D

signal player_triggered_enemy

func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Player":
		player_triggered_enemy.emit()
