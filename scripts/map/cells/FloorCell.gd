# Map Data representing floor cells.  Contained in Map Arrays.
class_name FloorCell
extends MapCell

# Constructor
func _init(x:int, y:int):
	position.x = x
	position.y = y
	glyph = "."
	walkable = true
