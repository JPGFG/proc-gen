# Work in progress class.  Feel free to play around with this if you like.

class_name PathFinder
extends Node2D

@export var tileMap : TileMapLayer
var game_map: GameMap
var start_point : Vector2i
var end_point : Vector2i
var enabled : bool = true

var path: Array[Vector2i] = []
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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and enabled:
		if start_point == Vector2i.ZERO && end_point == Vector2i.ZERO:
			start_point = tileMap.local_to_map(tileMap.get_local_mouse_position())
		elif start_point != Vector2i.ZERO && end_point == Vector2i.ZERO:
			end_point = tileMap.local_to_map(tileMap.get_local_mouse_position())
			path = djikstra_pathfind(start_point, end_point)
			queue_redraw()
		elif (start_point != Vector2i.ZERO && end_point != Vector2i.ZERO):
			clearPoints()
			clear_path()
		
		return


func show_path(new_path: Array[Vector2i]) -> void:
	path = new_path.duplicate(true)
	queue_redraw()

func clear_path() -> void:
	path.clear()
	queue_redraw()

func _draw() -> void:
	if path.is_empty() or tileMap == null:
		return
	
	var tile_size: Vector2 = Vector2(tileMap.tile_set.tile_size)
	
	for cell in path:
		var local_pos: Vector2 = tileMap.map_to_local(cell)
		var rect := Rect2(local_pos - tile_size * 0.5, tile_size)
		
		draw_rect(rect, Color(0.2, 0.6, 1.0, 0.4), true)

func get_walkable_neighbors(root: Vector2i) -> Array:
	var neighbors = []

	for i in range(0, 4):
		match i:
			0:
				var n = game_map.map[root.x][root.y - 1] as MapCell
				if n.walkable: neighbors.append(n)
			1:
				var n = game_map.map[root.x][root.y + 1] as MapCell
				if n.walkable: neighbors.append(n)
			2:
				var n = game_map.map[root.x + 1][root.y] as MapCell
				if n.walkable: neighbors.append(n)
			3:
				var n = game_map.map[root.x - 1][root.y] as MapCell
				if n.walkable: neighbors.append(n)
	return neighbors


func djikstra_pathfind(_start_point : Vector2i, _end_point : Vector2i) -> Array:
	var frontier : Array[Vector2i] = [] # nodes to explore next
	var came_from : Dictionary = {}
	var cost_so_far : Dictionary = {}
	
	frontier.append(_start_point)
	came_from[_start_point] = null
	cost_so_far[_start_point] = 0
	
	while frontier.size() > 0:
		# pick node with lowest cost
		@warning_ignore("confusable_local_declaration")
		var current = frontier[0]
		for node in frontier:
			if cost_so_far[node] < cost_so_far[current]:
				current = node
	
		frontier.erase(current)
		
		if current == _end_point:
			break
		
		for neighbor_cell in get_walkable_neighbors(current):
			var neighbor_pos = neighbor_cell.position
			var new_cost = cost_so_far[current] + 1
			
			if !cost_so_far.has(neighbor_pos) or new_cost < cost_so_far[neighbor_pos]:
				cost_so_far[neighbor_pos] = new_cost
				came_from[neighbor_pos] = current
				frontier.append(neighbor_pos)
				
	@warning_ignore("shadowed_variable")
	var path : Array[Vector2i] = []
	if not came_from.has(_end_point):
		print("No available Path.")
		return []
	
	var current = _end_point
	while current != null:
		path.insert(0, current)
		current = came_from.get(current, null)
	
	return path
