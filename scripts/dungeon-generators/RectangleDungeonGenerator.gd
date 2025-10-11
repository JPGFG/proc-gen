class_name RectangleDungeonGenerator
extends RefCounted

# This is a basic dungeon generator which builds rectangular rooms and connects them via
# horizontal-first corridor generation.  The GameMap class creates the board filled with
# Wall Cells, the initializer class then bakes whatever the generated map is into tiles
# This is done at the same time as the render map function.
# This simple dungeon generator was completed on 10/09/25.
# Written by JP Green at Columbia University.


var maxRooms: int
var minRooms: int
var maxRoomH: int
var maxRoomW: int
var minRoomdimension: int

var gameMap: GameMap

var roomlist = []


func _init(maximum_rooms:int, minimum_rooms:int, max_room_height:int, max_room_width:int, map:GameMap):
	self.maxRooms = maximum_rooms
	self.minRooms = minimum_rooms
	self.maxRoomH = max_room_height
	self.maxRoomW = max_room_width
	self.gameMap = map
	self.minRoomdimension = 2

func genDungeon():
	while roomlist.size() < maxRooms:
		genRectangleRoom()
	
	genCorridors()

func genRectangleRoom():
	var roomRect: Rect2i
	var roomW: int = randi_range(minRoomdimension, maxRoomW)
	var roomH: int = randi_range(minRoomdimension, maxRoomH)
	
	roomRect.position.x = randi_range(1, gameMap.map_w - 1 - roomW)
	roomRect.position.y = randi_range(1, gameMap.map_h - 1 - roomH)
	
	roomRect.end = Vector2i(roomRect.position.x + roomW, roomRect.position.y + roomH)
	
	for other in roomlist:
		if roomRect.intersects(other.grow(1)):
			return
	
	roomlist.append(roomRect)
	
	for dx in range(roomW):
		for dy in range(roomH):
			gameMap.map[roomRect.position.x + dx][roomRect.position.y + dy] = FloorCell.new(roomRect.position.x + dx, roomRect.position.y + dy)

func carveCorridor(start:Vector2i, end:Vector2i):
	var xdist: int
	var ydist: int
	var lastCoordinate:Vector2i = Vector2i.ZERO
	
	xdist = abs(start.x - end.x)
	ydist = abs(start.y - end.y)
	
	if start.x > end.x:
		for dx in range(xdist):
			gameMap.map[start.x-dx][start.y] = FloorCell.new(start.x-dx, start.y)
			lastCoordinate = Vector2i(start.x-dx, start.y)
	if start.x < end.x:
		for dx in range(xdist):
			gameMap.map[start.x+dx][start.y] = FloorCell.new(start.x+dx, start.y)
			lastCoordinate = Vector2i(start.x+dx, start.y)
	if start.x == end.x:
		pass
		lastCoordinate = Vector2i(start.x, start.y)
	if start.y > end.y:
		for dy in range(ydist):
			gameMap.map[lastCoordinate.x][start.y-dy] = FloorCell.new(lastCoordinate.x, start.y-dy)
	if start.y < end.y:
		for dy in range(ydist):
			gameMap.map[lastCoordinate.x][start.y+dy] = FloorCell.new(lastCoordinate.x, start.y-dy)
	if start.y == end.y:
		pass


func genCorridors():
	
	for i in roomlist.size() - 1:
		carveCorridor(roomlist[i].get_center(), roomlist[i+1].get_center())
