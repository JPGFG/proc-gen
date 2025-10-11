class_name DrunkWalkDungeonGenerator
extends RefCounted

# This is a demonstration of "a drunken walk" style of terrain generation.
# This can be used to generate water flows throughout a game map, or cavelike
# natural bounded terrain.  This generator written by JP at Columbia University
# on 10/10

var gameMap: GameMap
var walkedTiles = []
var walkers: int
var steps : int
var stepCounter: int = 0
var startPoint: Vector2i


func _init(game_map: GameMap, _steps: int, _walkers: int = 1):
	gameMap = game_map
	steps = _steps
	walkers = _walkers

func genDungeon():
	for i in range(walkers):
		startPoint = Vector2i(randi_range(1, gameMap.map_w - 1), randi_range(1, gameMap.map_h - 1))
		takeWalk()

func takeWalk():
	var currentStep: Vector2i
	currentStep = startPoint
	stepCounter = 0
	var directionArray = [1, 2, 3, 4]
	while stepCounter <= steps:
		var direction = directionArray[randi_range(0,3)]
		match direction:
			1:
				# UP
				currentStep = boundStep(currentStep + Vector2i.UP)
			2:
				# DOWN
				currentStep = boundStep(currentStep + Vector2i.DOWN)
			3:
				# LEFT
				currentStep = boundStep(currentStep + Vector2i.LEFT)
			4:
				# RIGHT
				currentStep = boundStep(currentStep + Vector2i.RIGHT)
		
		# Carve out the Cell at the step point
		gameMap.map[currentStep.x][currentStep.y] = FloorCell.new(currentStep.x, currentStep.y)
		stepCounter += 1

# Ensures drunken walk stays within the bounds of the array.
func boundStep(next_step: Vector2i) -> Vector2i:
	var validStep : Vector2i
	validStep.x = clamp(next_step.x, 0, gameMap.map_w - 1)
	validStep.y = clamp(next_step.y, 0, gameMap.map_h - 1)
	return validStep
