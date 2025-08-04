extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $PlayerAnimation

var body:int
var mind:int



func _on_walk_state_entered():
	anim.play("walk")

func _on_idle_state_entered():
	anim.play("idle")
