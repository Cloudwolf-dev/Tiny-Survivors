extends CharacterBody2D

#Player stats
const constante = 10
@export var crit_chance = 10
@export var speed: float = 300
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var player_controller = $PlayerController
@onready var state_machine = $StateMachine


@onready var hp = $HealthPoints
@onready var damage_area_pivot = $AreaDamagePivot
@onready var damage_area = $DamageArea
@onready var joystick_target_destination = $TargetDestinationPivot/TargetDestination
@onready var target_destination_pivot = $TargetDestinationPivot
@onready var target_attack = $TargetAttackPivot/TargetAttack
@onready var game_hud

@onready var health: int = 100
@onready var health_bar := $HealthBar
@onready var attack = $Attack

var is_dead := false

#Point&Click Movement
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@export var path_min_distance: float = 20
var target_position: Vector2


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_using_joystick: bool = false
var is_running: bool = false
var is_attacking: bool = false
var move_axis: Vector2 = Vector2.ZERO
var target_axis: Vector2 = Vector2.ZERO

var attack_cooldown:float = 0.8
var is_damage_critical = false

#func _ready():
	#game_hud = get_tree().get_nodes_in_group("HUD")[0]
	
func _input(event):
	if event is InputEventMouseMotion:
		is_using_joystick = false
	elif event is InputEventJoypadMotion:
		is_using_joystick = true

func _physics_process(delta: float) -> void:
	#print(velocity)
	if !is_dead:
		#get_joystick_left_axis()
		#get_joystick_right_axis()
	
		#health_update()

		var direction = Vector3()
		#Set player direction
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		#var distance_to_target = global_position.distance_to(get_global_mouse_position())
		
		#if distance_to_target >= 150:
			#print(global_position.distance_to(get_global_mouse_position()))
		#Attack anim
		#if Input.is_action_just_pressed("attack") && !is_attacking:
			#_attack()

		#print((global_position - get_global_mouse_position()).sign().x)
		#Set nav target
		#if (Input.is_action_just_pressed("left_mouse_button") || Input.is_action_pressed("left_mouse_button")) && !is_attacking && distance_to_target > path_min_distance:
			#nav.target_position = get_global_mouse_position()
			#animation_player.play("run")
			#is_running = true
			#is_attacking = false
			#pass
		if move_axis != Vector2.ZERO && !is_attacking:
			nav.target_position = joystick_target_destination.global_position
			animation_player.play("run")
			is_running = true
			is_attacking = false

		#if Input.is_action_just_pressed("cancel_attack") && is_attacking:
			#cancel_attack()
		
		if Input.is_action_just_pressed("take_damage") && state_machine.current_state != 3:
			hp.damage(randi_range(15,20))

		#Move player
		if state_machine.current_state == 1:
			#Flip Sprite
			flip_sprite(direction.x)
			#Aceleração do jogador
			velocity = direction * speed
			#Move Player
			move_and_slide()

#func get_joystick_left_axis():
	#move_axis.y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	#move_axis.x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
#
#func get_joystick_right_axis():
	#target_axis.y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	#target_axis.x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)

#func _attack():
	#state_machine._enter_state(state_machine.States.ATTACKING)
	#if is_using_joystick:
		#if global_position.x < damage_area_pivot.target_attack.global_position.x && sprite_2d.flip_h == true:
			#sprite_2d.flip_h = false
		#if global_position.x > damage_area_pivot.target_attack.global_position.x && sprite_2d.flip_h == false:
			#sprite_2d.flip_h = true
	#elif !is_using_joystick:
		#if global_position.x < get_global_mouse_position().x && sprite_2d.flip_h == true:
			#sprite_2d.flip_h = false
		#elif global_position.x > get_global_mouse_position().x && sprite_2d.flip_h == false:
			#sprite_2d.flip_h = true
	#if Input.is_action_just_pressed("turn_character"):
		#animation_player.play("idle")
		#return
	#animation_player.play("idle")
	#var which_attack: int = randi_range(1,2)
	#animation_player.play("attack" + str(which_attack))
	#pass

#func do_damage():
	#var bodies = damage_area.get_overlapping_bodies()
	#var crit = false
	#for body in bodies:
		#var damage = randi_range(20,20)
		#if body.hp != null:
			#body.hp.damage(damage)
		#pass

#func player_die():
	#queue_free()		

#func stop_attack():
	#state_machine._enter_state(state_machine.States.IDLE)
	#animation_player.play("idle")
#
#func cancel_attack():
	#is_attacking = false
	#animation_player.play("idle")

func flip_sprite(direction: float):
	if direction < 0:
		sprite_2d.flip_h = true
	elif direction > 0:
		sprite_2d.flip_h = false #EndRegion
#
#func _on_navigation_agent_2d_navigation_finished() -> void:
	#velocity = velocity
	#animation_player.play("idle")
	#is_running = false
	#pass
#
#
func _on_health_points_died():
	state_machine._enter_state(state_machine.States.DEAD)
	##damage_area_pivot.visible = false
	#animation_player.play("death")
	#pass
