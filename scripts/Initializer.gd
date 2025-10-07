extends Node2D

var gameMap: GameMap
var dungeonGenerator: DungeonGenerator
@export_category("Game Map Settings")
@export var width: int
@export var height: int

@export_category("Dungeon Generator Settings")
@export var maxRooms:int
@export var minRooms:int
@export var maxRoomHeight:int
@export var maxRoomWidth:int

func _ready():
	gameMap = GameMap.new(width, height)
	dungeonGenerator = DungeonGenerator.new(maxRooms, minRooms, maxRoomHeight, maxRoomWidth, gameMap)
	
	dungeonGenerator.genDungeon()
	
	gameMap.render()
