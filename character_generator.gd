extends Node2D

var duo = []
var driad = []
const cons = 'bcdfghjklmnpqrstvwxyz'
const vowel = 'aeiou'
const ender = 'gbdkptsrnmlf'

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
	for i in 10:
		generate_name()

func generate_name():
	print(driad[randi_range(0, driad.size())] + driad[randi_range(0, driad.size())])
	#print(driad[randi_range(0, driad.size())] + duo[randi_range(0, duo.size())])
