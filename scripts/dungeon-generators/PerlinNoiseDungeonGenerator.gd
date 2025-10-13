class_name PerlinNoiseDungeonGenerator
extends DungeonGenerator

# This is a dungeon generator based upon the use of Perlin Noise.
# This simple dungeon generator was completed on 10/12/25.
# Written by JP Green at Columbia University.

var noiseGenerator : FastNoiseLite

func _init(_game_map: GameMap, _seed : int = randi(), _fequency: float = 0.01, _fractal_octaves: int = 4, _fractal_lacunarity : float = 2.0, _fractal_gain: float = 0.5):
	gameMap = _game_map
	noiseGenerator = FastNoiseLite.new()
	noiseGenerator.noise_type = noiseGenerator.NoiseType.TYPE_PERLIN
	noiseGenerator.seed = _seed
	noiseGenerator.frequency = _fequency
	noiseGenerator.fractal_octaves = _fractal_octaves
	noiseGenerator.fractal_lacunarity = _fractal_lacunarity
	noiseGenerator.fractal_gain = _fractal_gain
	
	# Submit as magic number
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
