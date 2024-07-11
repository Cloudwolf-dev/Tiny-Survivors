extends Control

@onready var combat_log_label = $PanelContainer/HBoxContainer/CombatLogLabel
@onready var animation_player = $PanelContainer/HBoxContainer/CombatLogLabel/AnimationPlayer


func _ready():
	combat_log_label.text = ""
