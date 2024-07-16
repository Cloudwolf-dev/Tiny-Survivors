@icon("res://imported/rpgiab_icon_pack_v1.3/HealthPoints_16x.svg")
extends Control
class_name HealthPoints

@onready var damage_label = preload("res://scenes/damage_label.tscn")

var HEALTH_CAP: int = 1000
@export var MAX_HEALTH: int = 100
@export var HEALTH_BAR: ProgressBar

var health: float

var crit = false

signal died

func _ready():
	health = MAX_HEALTH

func _physics_process(delta):
	hp_update(health)

func damage(attack):
	
	
	if randi_range(1,10) > 8:
		crit = true
		attack *= 2
	else: crit = false
	health -= attack
	damage_text(crit, attack)
	pass

func damage_text(crit: bool, attack):
	var damage_tween
	var instance = damage_label.instantiate()
	instance.damage_text(attack)
	instance.crit = crit
	var label_settings = LabelSettings.new()
	label_settings.font_size = 20
	label_settings.font = preload("res://resources/fonts/Kenney Future.ttf")
	label_settings.outline_size = 8
	label_settings.outline_color = Color("000000", 100)
	if crit:
		label_settings.font_color = Color("e1bd00", 100)
	elif !crit:
		label_settings.font_color = Color("ff6666", 100)
	instance.label.label_settings = label_settings
	add_child(instance)

func hp_update(health):
	if health <= 0:
		health = 0
		HEALTH_BAR.visible = false
		emit_signal("died")
	elif health >= HEALTH_CAP:
		health = HEALTH_CAP
	HEALTH_BAR.value = (health / MAX_HEALTH) * 100
