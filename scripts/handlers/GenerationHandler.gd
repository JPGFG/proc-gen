class_name GenerationHandler
extends Control

enum dungeonType {RECT_CORRIDOR, DRUNKEN_WALK}

var generatorChoice = dungeonType
var dungeonGenerators := []

@onready var inputOptionContainer: VBoxContainer = $GenerationPanel/PanelContainer/VBoxContainer
var inputOption : PackedScene = preload("res://assets/scenes/input_option.tscn")

@onready var i_MAPHEIGHT_FIELD: LineEdit = $MapOptionsPanel/FIELD_HEIGHT
@onready var i_MAPWIDTH_FIELD: LineEdit = $MapOptionsPanel/FIELD_WIDTH

var inputOptionArray : Array[InputOption] = []

@export_category("TileMap Settings")
@export var tileMap : TileMapLayer

var floor_atlas := Vector2(0, 0)
var wall_atlas := Vector2(1, 0)

func _on_d_generator_button_item_selected(index):
	match index:
		0: generatorChoice = dungeonType.RECT_CORRIDOR
		1: generatorChoice = dungeonType.DRUNKEN_WALK
	setupGenUI(generatorChoice)

func generate():
	var _dungeonGenerator
	var _game_map : GameMap
	_game_map = GameMap.new(int(i_MAPWIDTH_FIELD.text), int(i_MAPHEIGHT_FIELD.text))
	match generatorChoice:
		dungeonType.RECT_CORRIDOR:
			var _max_rooms = int(inputOptionArray[0].inputField.text)
			var _min_rooms = int(inputOptionArray[1].inputField.text)
			var _max_room_w = int(inputOptionArray[2].inputField.text)
			var _max_room_h = int(inputOptionArray[3].inputField.text)
			_dungeonGenerator = RectangleDungeonGenerator.new(_max_rooms, _min_rooms, _max_room_h, _max_room_w, _game_map)
			_dungeonGenerator.genDungeon()
			bakeMap(_game_map)
		dungeonType.DRUNKEN_WALK:
			var _walkers = int(inputOptionArray[0].inputField.text)
			var _steps = int(inputOptionArray[1].inputField.text)
			_dungeonGenerator = DrunkWalkDungeonGenerator.new(_game_map, _steps, _walkers)
			_dungeonGenerator.genDungeon()
			bakeMap(_game_map)

func setupGenUI(type:dungeonType):
	match type:
		dungeonType.RECT_CORRIDOR:
			clearOptionUI()
			handle_rc_generation()
		dungeonType.DRUNKEN_WALK:
			clearOptionUI()
			handle_dw_generation()

func clearOptionUI():
	for option in inputOptionArray:
		option.call_deferred("queue_free")
	inputOptionArray.clear()

func handle_dw_generation():
	# Walkers
	add_input_option("Walkers")
	# Steps
	add_input_option("Steps")

func handle_rc_generation():
	# Max Rooms
	add_input_option("Max Rooms")
	# Min Rooms
	add_input_option("Min Rooms")
	# Max Room Width
	add_input_option("Max Room Width")
	# Max Room Height
	add_input_option("Max Room Height")

func add_input_option(_display_text: String):
	var option = inputOption.instantiate() as InputOption
	option.displayText.text = _display_text
	inputOptionContainer.add_child(option)
	inputOptionArray.append(option)

func _on_clear_entries_pressed():
	clearOptionUI()

func _on_generate_button_pressed():
	generate()

func bakeMap(game_map: GameMap) -> void:
	if tileMap == null:
		push_error("No Tile Map added to export field.")
		return
	
	tileMap.clear()
	@warning_ignore("unused_variable")
	var tileSet := tileMap.tile_set
	var source_id = tileMap.tile_set.get_source_id(0)
	for y in range(game_map.map_h):
		for x in range(game_map.map_w):
			var cell = game_map.map[x][y]
			var atlas := wall_atlas if (cell is WallCell) else floor_atlas
			tileMap.set_cell(Vector2i(x, y), source_id, atlas)
