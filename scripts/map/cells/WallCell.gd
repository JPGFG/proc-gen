class_name WallCell
extends MapCell

func _init(x:int, y:int):
	position.x = x
	position.y = y
	glyph = "#"
	walkable = false
