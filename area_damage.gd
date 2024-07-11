extends Node2D

@onready var player = $".."
@onready var slash_sprite = $Area2D/SlashSprite
@onready var target_attack_pivot = $"../TargetAttackPivot"
@onready var target_attack = $"../TargetAttackPivot/TargetAttack"

var deadzone = 0.3


func _process(delta):
	if player.is_attacking:
		#slash_sprite.visible = true
		return
	elif !player.is_attacking && player.target_axis == Vector2.ZERO && !player.is_using_joystick:
		#slash_sprite.visible = false
		look_at(get_global_mouse_position())
	elif !player.is_attacking && player.target_axis != Vector2.ZERO && player.is_using_joystick:
		look_at(target_attack.global_position)

func _physics_process(delta):
	attack_towards()

func attack_towards():
	if player.target_axis.length() >= deadzone && !player.is_attacking:
		target_attack_pivot.rotation = player.target_axis.angle()

