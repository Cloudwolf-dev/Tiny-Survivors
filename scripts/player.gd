extends CharacterBody2D

#Player stats
const constante = 10
@export var crit_chance = 10
@export var speed: float = 300
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var damage_area_pivot = $AreaDamagePivot
@onready var damage_area = $AreaDamagePivot/Area2D
@onready var joystick_target_destination = $TargetDestinationPivot/TargetDestination
@onready var target_destination_pivot = $TargetDestinationPivot
@onready var target_attack = $TargetAttackPivot/TargetAttack
@onready var game_hud

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

func _ready():
	game_hud = get_tree().get_nodes_in_group("HUD")[0]
	
func _input(event):
	if event is InputEventMouseMotion:
		is_using_joystick = false
	elif event is InputEventJoypadMotion:
		is_using_joystick = true

func _physics_process(delta: float) -> void:
	get_joystick_left_axis()
	get_joystick_right_axis()
	var direction = Vector3()
	#Set player direction
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	var distance_to_target = global_position.distance_to(get_global_mouse_position())
	
	#if distance_to_target >= 150:
		#print(global_position.distance_to(get_global_mouse_position()))
	#Attack anim
	if Input.is_action_just_pressed("attack") && !is_attacking:
		attack()

	#Set nav target
	if (Input.is_action_just_pressed("left_mouse_button") || Input.is_action_pressed("left_mouse_button")) && !is_attacking && distance_to_target > path_min_distance:
		nav.target_position = get_global_mouse_position()
		animation_player.play("run")
		is_running = true
		is_attacking = false
	if move_axis != Vector2.ZERO && !is_attacking:
		nav.target_position = joystick_target_destination.global_position
		animation_player.play("run")
		is_running = true
		is_attacking = false

	if Input.is_action_just_pressed("cancel_attack") && is_attacking:
		cancel_attack()

	#Move player
	if is_running:
		#Flip Sprite
		flip_sprite(direction.x)
		#Aceleração do jogador
		velocity = direction * speed
		#Move Player
		move_and_slide()

func get_joystick_left_axis():
	move_axis.y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	move_axis.x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)

func get_joystick_right_axis():
	target_axis.y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	target_axis.x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)

func attack():
	is_running = false
	is_attacking = true
	if is_using_joystick:
		if global_position.x < damage_area_pivot.target_attack.global_position.x && sprite_2d.flip_h == true:
			sprite_2d.flip_h = false
		if global_position.x > damage_area_pivot.target_attack.global_position.x && sprite_2d.flip_h == false:
			sprite_2d.flip_h = true
	elif !is_using_joystick:
		if global_position.x < get_global_mouse_position().x && sprite_2d.flip_h == true:
			sprite_2d.flip_h = false
		elif global_position.x > get_global_mouse_position().x && sprite_2d.flip_h == false:
			sprite_2d.flip_h = true
	if Input.is_action_just_pressed("turn_character"):
		animation_player.play("idle")
		return

	animation_player.play("idle")
	var which_attack: int = randi_range(1,2)
	animation_player.play("attack" + str(which_attack))
	pass

func do_damage():
	var bodies = damage_area.get_overlapping_bodies()
	var crit = false
	for body in bodies:
		crit_chance = randi_range(2,10)
		var damage = randi_range(30,40)
		if crit_chance > 7:
			damage *= 2
			game_hud.combat_log_label.text = "Critical!"
			crit = true
		else: 
			crit = false
		body.is_damage_critical = is_damage_critical
		body.damage(damage, crit)
		pass

func stop_attack():
	is_attacking = false
	animation_player.play("idle")

func cancel_attack():
	is_attacking = false
	animation_player.play("idle")

func flip_sprite(direction: float):
	if direction < 0:
		sprite_2d.flip_h = true
	elif direction > 0:
		sprite_2d.flip_h = false #EndRegion

func _on_navigation_agent_2d_navigation_finished() -> void:
	velocity = velocity
	animation_player.play("idle")
	is_running = false
	pass # Replace with function body.
