@icon("res://imported/rpgiab_icon_pack_v1.3/PlayerController_16x.svg")
class_name PlayerController
extends Node2D

var left_stick: Vector2
var right_stick: Vector2
var mouse_position: Vector2

@onready var sprite = $"../Sprite2D"
@onready var damage_area := $"../DamageArea/Area2D"
@onready var player = $".."
@onready var animation_player = $"../AnimationPlayer"
@onready var nav = $"../NavigationAgent2D"
@onready var state_machine: StateMachine = $"../StateMachine"
@onready var distance_to_target

@export var path_min_distance: float = 50

func _ready():
	mouse_position = Vector2.ZERO

func _input(event):
	left_stick = Vector2(
	Input.get_joy_axis(0, JOY_AXIS_LEFT_Y),
	Input.get_joy_axis(0, JOY_AXIS_LEFT_X))
	right_stick = Vector2(
	Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y),
	Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
	
	mouse_position = get_global_mouse_position()
	
	


func _physics_process(delta):
	distance_to_target = global_position.distance_to(get_global_mouse_position())
	match state_machine.current_state:
		0: #IDLE
			_move()
			_attack()
		1: #RUNNING
			_move()
			_attack()
		2: #ATTACK
			_cancel_attack()
			pass
		3: #DEAD
			animation_player.play("death")
	pass

func _move():
	if (Input.is_action_just_pressed("left_mouse_button") || Input.is_action_pressed("left_mouse_button")) && distance_to_target > path_min_distance:
		state_machine._enter_state(state_machine.States.RUNNING)
		nav.target_position = get_global_mouse_position()
		animation_player.play("run")
	pass

func _jump(): #TODO
	pass

func _attack():
	if Input.is_action_just_pressed("attack") && state_machine.current_state != 2:
		_flip_sprite()	
		state_machine._enter_state(state_machine.States.ATTACKING)
		animation_player.play("idle")
		var which_attack: int = randi_range(1,2)
		animation_player.play("attack" + str(which_attack))
		
func do_damage():
	var bodies = damage_area.get_overlapping_bodies()
	var crit = false
	for body in bodies:
		var damage = randi_range(20,20)
		if !body.is_dead:
			body.hp.damage(damage)
		pass
	pass

func stop_attack():
	state_machine._enter_state(state_machine.States.IDLE)
	animation_player.play("idle")

func _cancel_attack():
	if Input.is_action_just_pressed("cancel_attack"):
		animation_player.play("idle")
		state_machine._enter_state(state_machine.States.IDLE)

func _flip_sprite():
	if (player.global_position - damage_area.global_position).sign().x == 1:
		sprite.flip_h = true
	elif (player.global_position - damage_area.global_position).sign().x == -1:
		sprite.flip_h = false

func _on_navigation_agent_2d_navigation_finished():
	player.velocity = player.velocity
	state_machine._enter_state(state_machine.States.IDLE)
	animation_player.play("idle")
	pass # Replace with function body.
