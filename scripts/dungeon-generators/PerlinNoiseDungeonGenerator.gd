class_name PerlinNoiseDungeonGenerator
extends DungeonGenerator

var noiseGenerator : FastNoiseLite

func _init(_game_map: GameMap, _seed : int = randi(), _fequency: float = 0.01):
	gameMap = _game_map
	noiseGenerator = FastNoiseLite.new()
	noiseGenerator.noise_type = noiseGenerator.NoiseType.TYPE_PERLIN
	noiseGenerator.seed = _seed
	noiseGenerator.frequency = _fequency
	
	# Export these values to UI
	noiseGenerator.fractal_octaves = 4
	noiseGenerator.fractal_lacunarity = 2.0
	noiseGenerator.fractal_gain = 0.5
	noiseGenerator.fractal_weighted_strength = 0.0



func genDungeon():
	for x in range(1, gameMap.map_w - 1):
		for y in range(1, gameMap.map_h - 1):
			var dx := randf_range(-0.5, 0.5)
			var dy := randf_range(-0.5, 0.5)
			var n := noiseGenerator.get_noise_2d(x + dx, y + dy)
			if n >= 0:
				gameMap.map[x][y] = FloorCell.new(x, y)
			else:
				gameMap.map[x][y] = WallCell.new(x, y)
