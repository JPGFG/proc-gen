class_name Initializer
extends Node2D

var gameMap: GameMap
@export_category("Game Map Settings")
@export var width: int
@export var height: int

@export_category("TileMap Settings")
@export var tileMap : TileMapLayer

var floor_atlas := Vector2(0, 0)
var wall_atlas := Vector2(1, 0)


func _ready():
	var dungeonGenerator: DungeonGenerator
	gameMap = GameMap.new(width, height)
	# Dungeon Generator Testing Zone
	# Initialize your dungeonGenerator then render the map, final test is baking.
	dungeonGenerator = CellularAutomataDungeonGenerator.new(gameMap, 0.45, 6, 3, 3)
	
	dungeonGenerator.genDungeon()
	# // End Dungeon Generator Testing Zone 
	bakeMap(gameMap)
	
	# Pathfinding Testing Zone
	var pathfinder = PathFinder.new(gameMap, tileMap)
	add_child(pathfinder)
	
	# // End Pathfinding Testing Zone


func bakeMap(game_map: GameMap) -> void:
	if tileMap == null:
		push_error("No Tile Map added to export field.")
		return
	
	tileMap.clear()
	@warning_ignore("unused_variable")
	var tileSet := tileMap.tile_set
	var source_id = tileMap.tile_set.get_source_id(0)
	for y in range(game_map.map_h):
		for x in range(game_map.map_w):
			var cell = game_map.map[x][y]
			var atlas := wall_atlas if (cell is WallCell) else floor_atlas
			tileMap.set_cell(Vector2i(x, y), source_id, atlas)
