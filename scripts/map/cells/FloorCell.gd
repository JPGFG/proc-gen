class_name FloorCell
extends MapCell

func _init(x:int, y:int):
	position.x = x
	position.y = y
	glyph = "."
	walkable = true
