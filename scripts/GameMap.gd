class_name GameMap
extends RefCounted

var map_h: int
var map_w: int
var mapRect: Rect2i

var map = []

func _init(map_width:int, map_height:int):
	map_h = map_height
	map_w = map_width
	mapRect = Rect2i(Vector2i.ZERO, Vector2i(map_w, map_h))
	
	fillMap()

func fillMap():
	for x in map_w:
		map.append([])
		for y in map_h:
			map[x].append(WallCell.new(x, y))

func render():
	var renderRow: String = ""
	for y in range(map_h):
		renderRow = ""
		for x in range(map_w):
			renderRow += map[x][y].glyph + " "
		print(renderRow)
