class_name PathFinder
extends Node2D

@export var tileMap : TileMapLayer
var game_map: GameMap
var start_point : Vector2i
var end_point : Vector2i
var enabled : bool = true

# tileMap.local_to_map(tileMap.get_local_mouse_position()) Returns the local tile location in the grid.

func _init(_game_map : GameMap, _tile_map : TileMapLayer):
	game_map = _game_map
	tileMap = _tile_map
	start_point = Vector2.ZERO
	end_point = Vector2.ZERO
	# enabled = false # (for later)

func clearPoints():
	start_point = Vector2i.ZERO
	end_point = Vector2i.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and enabled:
		if start_point == Vector2i.ZERO && end_point == Vector2i.ZERO:
			start_point = tileMap.local_to_map(tileMap.get_local_mouse_position())
			print(start_point)
		elif start_point != Vector2i.ZERO && end_point == Vector2i.ZERO:
			end_point = tileMap.local_to_map(tileMap.get_local_mouse_position())
			print(end_point)
			print("do djikstra")
			print (start_point.distance_to(end_point))
		elif (start_point != Vector2i.ZERO && end_point != Vector2i.ZERO):
			clearPoints()
		
		return

func pathfind(_start_point : Vector2i, _end_point : Vector2i):
	pass
