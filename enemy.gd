extends StaticBody2D

signal player_triggered_enemy

var str = randi_range(0,10)
var wis = randi_range(0,10)

func _ready():
	print(str, " " ,wis)

func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Player":
		player_triggered_enemy.emit()
