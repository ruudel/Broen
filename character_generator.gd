extends Node2D

var vowel = ['a', 'e', 'i', 'o', 'u']
var duo = []
var driad = []
const cons = 'bcdfghjklmnpqrstvwxyz'
const ender = 'kptsrnmlf'

var vowelsize = 0
var duosize = 0
var driadsize = 0

func _ready():
	for i in cons:
		for j in vowel:
			duo.append(i+j)
	for i in cons:
		for j in vowel:
			for j2 in vowel:
				driad.append(i+j+j2)
			for k in ender:
				driad.append(i+j+k)
	vowelsize = vowel.size()-1
	duosize = duo.size()-1
	driadsize = driad.size()-1


func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		generate_name()


func generate_name():
	#Length is in syllables
	#print(driad[randi_range(0, driadsize)] + driad[randi_range(0, driadsize)])

	#print(driad[randi_range(0, driad.size()-1)] + duo[randi_range(0, duo.size())])

	print(vowel[randi_range(0, vowelsize)] + driad[randi_range(0, driadsize)] + vowel[randi_range(0, vowelsize)])
