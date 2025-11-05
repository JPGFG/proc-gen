# Abstract class for Cells held in map_data arrays.
class_name MapCell
extends RefCounted

var position: Vector2i
var glyph: String # what is shown on a console render
var walkable: bool # used for pathfinding system
