extends CharacterBody2D

@export var current_health: int = 100
@export var max_health: int = 250
@onready var health_bar = $HealthBar
@onready var damage_label = preload("res://scenes/damage_label.tscn")
@onready var collision: CollisionShape2D = $CollisionShape2D


@onready var ani_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_range: Area2D = $AttackRange
@onready var detection_area: Area2D = $DetectionArea
@export var speed: int = 175
var player: Node
var player_position: Vector2
var input_vector := Vector2.ZERO
var can_follow := true
var is_dead := false
var is_damage_critical = false


func _process(delta):
	#print(can_follow)
	if current_health <= 0:
		current_health = 0
		#Play death animation, disable collision, disable collision and set player as dead.
		ani_sprite.play("death")
		collision.disabled = true
		health_bar.visible = false
		is_dead = true

	health_bar.value = ( float(current_health) / float(max_health) ) * 100

func _physics_process(delta):
	flip_sprite(input_vector.x)
	check_targets()
	if !is_dead:
		if player != null && can_follow : follow_player()
		else : ani_sprite.play("idle")

func damage(amount: int, crit: bool):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	print("Current Health: ", current_health)
	var damage_tween
	var instance = damage_label.instantiate()
	instance.damage_text(amount)
	instance.crit = crit
	if crit:
		var label_settings = LabelSettings.new()
		label_settings.font_color = Color("e1bd00", 100)
		label_settings.font_size = 20
		label_settings.font = preload("res://resources/fonts/Kenney Future.ttf")
		label_settings.outline_size = 8
		label_settings.outline_color = Color("000000", 100)
		instance.label.label_settings = label_settings
	elif !crit:
		var label_settings = LabelSettings.new()
		label_settings.font_color = Color("ff6666", 100)
		label_settings.font_size = 20
		label_settings.font = preload("res://resources/fonts/Kenney Future.ttf")
		label_settings.outline_size = 8
		label_settings.outline_color = Color("000000", 100)
		instance.label.label_settings = label_settings
	add_child(instance)
	pass

func flip_sprite(direction: float):
	if direction > 0:
		ani_sprite.flip_h = false
	elif direction < 0:
		ani_sprite.flip_h = true

func follow_player():
	player_position = player.global_position
	input_vector = (player_position - global_position).normalized()
	ani_sprite.play("run")
	velocity = input_vector * speed
	move_and_slide()

func check_targets():
	var bodies = detection_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			player = body

func _on_detection_area_body_exited(body):
	player = null

func _on_tween_finished():pass

func _on_animated_sprite_2d_frame_changed():
	if ani_sprite.animation == "attack1":
		if ani_sprite.frame == 1:
			can_follow = false
		if ani_sprite.frame == 5:
			can_follow = true
	
	if ani_sprite.animation == "death":
		if ani_sprite.frame == 19:
			self.queue_free()
	pass # Replace with function body.
