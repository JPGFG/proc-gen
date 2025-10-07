class_name DungeonGenerator
extends RefCounted

var maxRooms: int
var minRooms: int
var maxRoomH: int
var maxRoomW: int
var minRoomdimension: int

var gameMap: GameMap

var roomlist = []


func _init(maxRooms:int, minRooms:int, maxRoomH:int, maxRoomW:int, map:GameMap):
	self.maxRooms = maxRooms
	self.minRooms = minRooms
	self.maxRoomH = maxRoomH
	self.maxRoomW = maxRoomW
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
