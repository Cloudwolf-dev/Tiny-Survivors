@icon("res://imported/rpgiab_icon_pack_v1.3/16x16/location_character.png")
class_name FollowPlayer
extends CharacterBody2D

var speed = 100
@onready var game_manager

func _ready():
	game_manager = get_tree().get_nodes_in_group("Game Manager")[0]

func _physics_process(delta):
