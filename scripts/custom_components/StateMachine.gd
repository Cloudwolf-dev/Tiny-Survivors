@icon("res://imported/rpgiab_icon_pack_v1.3/StateMachine_16x.svg")
extends Node
class_name StateMachine
@onready var state = $"../State"

@export var current_state: States
enum States {
	IDLE,
	RUNNING,
	ATTACKING,
	DEAD
}

func _ready():
	current_state = States.IDLE

func _process(delta):
	match current_state:
		0:
			state.text = "Idle"
		1:
			state.text = "Running"
		2:
			state.text = "Attacking"
			#print("attack!")
		3:
			state.text = "Dead"
	pass

func _enter_state(new_state: int):
	current_state = new_state
	pass

#func _exit_state(state: States):
	#pass
