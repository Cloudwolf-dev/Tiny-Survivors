extends Node2D
@onready var label: Label = $Label
var crit = false

var tween: Tween = create_tween()
func _ready():
	pass 

func _process(delta):
	tween = create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(self, "position", Vector2(0, -169), .6)
	tween.parallel().tween_property(self, "modulate:a", 0, .9).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if crit:
		tween.parallel().tween_property(self, "scale", Vector2(1.4,1.4), .2)

func damage_text(amount):
	label = $Label
	label.text = str(amount)

func _on_tween_finished():
	self.queue_free()
	
