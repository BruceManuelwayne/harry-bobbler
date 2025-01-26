extends Area2D

signal bubble_protection_activate
signal bubble_protection_deactivate

@export var consumption: int
var enabled: bool

func _ready() -> void:
	enabled = true
	deactivate()


func _process(delta: float) -> void:
	if Input.is_action_pressed("action"):
		if enabled:
			activate()
	else:
		deactivate()

func activate() -> void:
	show()
	set_collision_mask_value(2, true)
	bubble_protection_activate.emit()
	
func deactivate() -> void:
	hide()
	set_collision_mask_value(2, false)
	bubble_protection_deactivate.emit()



func _on_area_entered(area: Area2D) -> void:
	area.hide()
	area.queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.hide()
	body.queue_free()
