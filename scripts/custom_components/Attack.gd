@icon("res://imported/rpgiab_icon_pack_v1.3/Attack.svg")
extends Node
class_name Attack

@export_subgroup("Base Damage")
@export var attack_damage: int = 10
@export_range(1,99) var critical_chance: float = 10
@export_range(100, 150, 1) var critical_damage: int = 100

@export_subgroup("Modifiers")
@export var mod1: int = 0
@export var mod2: int = 0
@export var mod3: int = 0
