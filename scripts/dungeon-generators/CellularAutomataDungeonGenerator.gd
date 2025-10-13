class_name CellularAutomataDungeonGenerator
extends DungeonGenerator


# float values 0.0 - 1.0
var place_threshold : float
var survival_threshold: int
var birth_threshold: int
var desired_generations: int


func _init(_game_map: GameMap, _place_threshold : float, _survival_threshold: int, _birth_threshold: int, _desired_generations : int):
	gameMap = _game_map
	place_threshold = _place_threshold
	survival_threshold = _survival_threshold
	birth_threshold = _birth_threshold
	desired_generations = _desired_generations

func genDungeon():
	
	# World Setup
	for x in range(1, gameMap.map_w - 1):
		for y in range(1, gameMap.map_h - 1):
			var placement_chance = randf_range(0, 1)
			if placement_chance <= place_threshold:
				gameMap.map[x][y] = FloorCell.new(x, y)
			else:
				gameMap.map[x][y] = WallCell.new(x, y)
	
	# Begin Game of Life
	for current_generation in range(desired_generations):
		for x in range(1, gameMap.map_w - 1):
			for y in range(1, gameMap.map_h - 1):
				var live_neighbors = getLiveNeighbors(gameMap.map[x][y])
				if gameMap.map[x][y] is FloorCell: # ALIVE
					if live_neighbors <= survival_threshold:
						gameMap.map[x][y] = WallCell.new(x, y)
				else: # IF WALLCELL (DEAD)
					if live_neighbors >= birth_threshold:
						gameMap.map[x][y] = FloorCell.new(x, y)


func getLiveNeighbors(_cell : MapCell) -> int:
	var live_neighbors : int = 0
	var pos = _cell.position
	for i in range(1, 8):
		match i:
			1:
				# UP
				if (gameMap.map[pos.x][pos.y + -1] is FloorCell):
					live_neighbors += 1
			2:
				# DOWN
				if (gameMap.map[pos.x][pos.y + 1] is FloorCell):
					live_neighbors += 1
			3:
				# LEFT
				if (gameMap.map[pos.x - 1][pos.y] is FloorCell):
					live_neighbors += 1
			4:
				# RIGHT
				if (gameMap.map[pos.x + 1][pos.y] is FloorCell):
					live_neighbors += 1
			5:
				# UP-RIGHT
				if (gameMap.map[pos.x - 1][pos.y + 1] is FloorCell):
					live_neighbors += 1
			6:
				# UP-LEFT
				if (gameMap.map[pos.x -1][pos.y - 1] is FloorCell):
					live_neighbors += 1
			7:
				# DOWN-LEFT
				if (gameMap.map[pos.x - 1][pos.y + 1] is FloorCell):
					live_neighbors += 1
			8:
				# DOWN-RIGHT
				if (gameMap.map[pos.x + 1][pos.y + 1] is FloorCell):
					live_neighbors += 1
	return live_neighbors
