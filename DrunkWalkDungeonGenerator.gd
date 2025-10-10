class_name DrunkWalkDungeonGenerator
extends RefCounted

var gameMap: GameMap
var walkedTiles = []
var steps : int
var stepCounter: int = 0
var startPoint: Vector2


func _init(game_map: GameMap, _steps: int, start_point:= Vector2(randi_range(1, game_map.map_w - 1), randi_range(1, game_map.map_h - 1))):
	gameMap = game_map
	steps = _steps
	startPoint = start_point

func genDungeon():
	var currentStep: Vector2
	currentStep = startPoint
	
	var directionArray = [1, 2, 3, 4]
	while stepCounter <= steps:
		var direction = directionArray[randi_range(0,3)]
		match direction:
			1:
				# UP
				currentStep.y -= 1
			2:
				# DOWN
				currentStep.y += 1
			3:
				# LEFT
				currentStep.x -= 1
			4:
				# RIGHT
				currentStep.x += 1
