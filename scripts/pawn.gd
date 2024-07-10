extends CharacterBody2D

@export var current_health: int = 100
@export var max_health: int = 250
@onready var health_bar = $HealthBar

@onready var ani_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@export var speed: int = 175
var player: Node
var player_position: Vector2
var input_vector := Vector2.ZERO
var can_follow := true


func _process(delta):
	#print(can_follow)
	if current_health <= 0:
		current_health = 0
		self.queue_free()
	health_bar.value = ( float(current_health) / float(max_health) ) * 100

func _physics_process(delta):
	flip_sprite(input_vector.x)
	check_targets()
	if player != null && can_follow : follow_player()
	else : ani_sprite.play("idle")

func damage(amount: int):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	print("Current Health: ", current_health)
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


func _on_animated_sprite_2d_frame_changed():
	if ani_sprite.animation == "attack1":
		if ani_sprite.frame == 1:
			can_follow = false
		if ani_sprite.frame == 5:
			can_follow = true
	pass # Replace with function body.
