extends StaticBody2D

signal player_triggered_event

var char_name:String

var first = []
var last = []
var vow = 'aioue'
var cons = 'kptgpdrlsmn'
var names = []

func _ready():
	for i in vow:
		for j in cons:
			first.append(i)
			first.append(i+i)
			first.append(j+i)
			first.append(i+j)
			first.append(j+i+'r')
			first.append(j+i+'s')
			first.append(j+i+'k')
			first.append(j+i+'p')
			first.append(j+i+'n')
			last.append(j+i)
			last.append(j+i+'r')
			last.append(j+i+'s')
			last.append(j+i+'k')
			last.append(j+i+'p')
			last.append(j+i+'n')
	
	for i in first:
		for j in last:
			names.append(i+j)
	char_name = names[randi_range(0, len(names))].capitalize()
	

func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Player":
		player_triggered_event.emit(char_name, "npc")
