class_name Initializer
extends Node2D

var gameMap: GameMap
var rectangle_dungeon_generator: RectangleDungeonGenerator
var drunk_walk_generator: DrunkWalkDungeonGenerator
@export_category("Game Map Settings")
@export var width: int
@export var height: int

@export_category("Rectangle Dungeon Generator Settings")
@export var maxRooms:int
@export var minRooms:int
@export var maxRoomHeight:int
@export var maxRoomWidth:int

@export_category("TileMap Settings")
@export var tileMap : TileMapLayer

var floor_atlas := Vector2(0, 0)
var wall_atlas := Vector2(1, 0)


func _ready():
	
	gameMap = GameMap.new(width, height)
	
	drunk_walk_generator = DrunkWalkDungeonGenerator.new(gameMap, 400, 8)
	drunk_walk_generator.genDungeon()
	# rectangle_dungeon_generator = RectangleDungeonGenerator.new(maxRooms, minRooms, maxRoomHeight, maxRoomWidth, gameMap)
	# rectangle_dungeon_generator.genDungeon()
	
	# gameMap.render()
	bakeMap(gameMap)


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
