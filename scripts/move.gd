extends Node2D

@onready var player = $".."

var deadzone = 0.3

func _physics_process(delta):
	move_rotate()

func move_rotate():
	if player.move_axis.length() >= deadzone:
		rotation = player.move_axis.angle()
	pass
