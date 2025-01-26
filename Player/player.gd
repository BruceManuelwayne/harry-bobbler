extends Area2D

signal hit
signal game_over
signal up_generation
signal middle_generation
signal down_generation

@export var mana: float
var current_mana: float
var is_protection_bubble_active: bool

var playerPath
var lastPosition

enum CurrentMovementType{
	MOVE_UP,
	MOVE_MIDDLE,
	MOVE_DOWN
}

var CurrentMovement

@export var speed: int = 80
var tileSize = 16
var pathLenght = 22
var stairLenght = 4
var pathLenghtInPixel = pathLenght * tileSize

var life

func _ready() -> void:
	position.x = -144
	life = 3
	is_protection_bubble_active = false
	current_mana = mana

	CurrentMovement = CurrentMovementType.MOVE_MIDDLE
	stairsMovement()


func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_just_pressed("up"):
		CurrentMovement = CurrentMovementType.MOVE_UP
	if Input.is_action_just_pressed("down"):
		CurrentMovement = CurrentMovementType.MOVE_DOWN
		
	update_mana(delta)

func stairsMovement():
	var tween = create_tween()
	var newPosition = position
	
	if CurrentMovement == CurrentMovementType.MOVE_UP:
		newPosition = position + Vector2(80.0,-64.0)
		tween.tween_property(self,"position",newPosition,1)
		
	if CurrentMovement == CurrentMovementType.MOVE_DOWN:
		newPosition = position + Vector2(90.0,64.0)
		tween.tween_property(self,"position", newPosition,1)
		
	tween.tween_property(self,"position", newPosition + Vector2(pathLenghtInPixel, 0), pathLenghtInPixel / 80)
	CurrentMovement = CurrentMovementType.MOVE_MIDDLE

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		get_hit()
	
	if body.is_in_group("wall"):
		hit.emit()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("up_generation"):
		up_generation.emit()
		
	if area.is_in_group("middle_generation"):
		middle_generation.emit()

	if area.is_in_group("down_generation"):
		down_generation.emit()
		
	if area.is_in_group("stairs"):
		stairsMovement()
		
	if area.is_in_group("enemies"):
		print(area)
		get_hit()
		area.queue_free()
		
func get_hit() -> void:
	print("Get Hit")
	life -= 1
	hit.emit()
	if life == 0:
		game_over.emit()
		
func update_mana(delta: float) -> void:
	if is_protection_bubble_active:
		current_mana -= $ProtectionBubble.consumption * delta
		
		if current_mana <= 0:
			$ProtectionBubble.enabled = false
			$ProtectionBubble.deactivate()


func _on_protection_bubble_bubble_protection_activate() -> void:
	is_protection_bubble_active = true
	set_collision_mask_value(2, false)


func _on_protection_bubble_bubble_protection_deactivate() -> void:
	is_protection_bubble_active = false
	set_collision_mask_value(2, true)
