extends Node


# Called when the node enters the scene tree for the first time.
var score = 0

@onready var label: Label = $Label

func add_point():
	score += 1
	label.text = "Coins: " + str(score)
