extends Node2D

var mazeBlockCommon
var mazeBlockUp
var mazeBlockMiddle
var mazeBlockDown
var mazeBlockFinal

var tileSize = 16
var pathLenght = 22

var currentGen

var lastCrossPosition

enum DirectionType {
	UP,
	MIDDLE,
	DOWN
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mazeBlockCommon = load("res://Maze/MapBlockCommon.tscn")
	mazeBlockUp = load("res://Maze/MapBlockUp.tscn")
	mazeBlockMiddle = load("res://Maze/MapBlockMiddle.tscn")
	mazeBlockDown = load("res://Maze/MapBlockDown.tscn")
	mazeBlockFinal = load("res://Maze/MapBlockFinal.tscn")
	var blockInstance = mazeBlockCommon.instantiate()
	add_child(blockInstance)
	lastCrossPosition = Vector2(0.0,0.0)
	currentGen=0
	
	$HUD.update_life($Player.life)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mana_percentage = $Player.current_mana * 100 / $Player.mana
	$HUD.update_mana(mana_percentage)
	
func SpawnNewBlock(direction : DirectionType):
	var blockInstance
	
	#lastCrossPosition = Vector2(lastCrossPosition.x + tileSize * pathLenght, lastCrossPosition.y)
	if direction == DirectionType.UP:
		lastCrossPosition = Vector2(lastCrossPosition.x+ 352.0,lastCrossPosition.y +  -64.0)
		blockInstance = mazeBlockUp.instantiate()
	elif direction == DirectionType.MIDDLE:
		lastCrossPosition = Vector2(lastCrossPosition.x+ 352.0,lastCrossPosition.y + 0.0)
		blockInstance = mazeBlockMiddle.instantiate()
	elif direction == DirectionType.DOWN:
		lastCrossPosition = Vector2(lastCrossPosition.x+ 352.0,lastCrossPosition.y + 64.0)
		blockInstance = mazeBlockDown.instantiate()
		
	if(currentGen==8):
		blockInstance = mazeBlockFinal.instantiate()
		add_child(blockInstance)
		blockInstance.position = lastCrossPosition
	else:
		add_child(blockInstance)
		blockInstance.position = lastCrossPosition
		$Spawn.Spawn(blockInstance,currentGen)
		currentGen+=1
		
	


func _on_player_up_generation() -> void:
	SpawnNewBlock(DirectionType.UP)


func _on_player_middle_generation() -> void:
	SpawnNewBlock(DirectionType.MIDDLE)


func _on_player_down_generation() -> void:
	SpawnNewBlock(DirectionType.DOWN)


func _on_player_stairs() -> void:
	pass # Replace with function body.


func _on_player_hit() -> void:
	$HUD.update_life($Player.life)
