class_name GenerationHandler
extends Control

enum dungeonType {RECT_CORRIDOR, DRUNKEN_WALK, PERLIN_NOISE, CELLULAR_AUTOMATA}
var generatorChoice = dungeonType
var dungeonGenerators := []

@onready var inputOptionContainer: VBoxContainer = $GenerationPanel/PanelContainer/VBoxContainer
var inputOption : PackedScene = preload("res://assets/scenes/input_option.tscn")

@onready var i_MAPHEIGHT_FIELD: LineEdit = $MapOptionsPanel/FIELD_HEIGHT
@onready var i_MAPWIDTH_FIELD: LineEdit = $MapOptionsPanel/FIELD_WIDTH

@onready var warningPanel: Control = $Warning
@onready var warningLabel: RichTextLabel = $Warning/WarningPanel/WarningText

var inputOptionArray : Array[InputOption] = []

@export_category("TileMap Settings")
@export var tileMap : TileMapLayer

var floor_atlas := Vector2(0, 0)
var wall_atlas := Vector2(1, 0)

#TODO implement x to toggle UI
func _unhandled_key_input(event):
	if event.is_pressed() and event.keycode == KEY_X:
		if self.visible == true: self.visible = false
		else: self.visible = true

func _on_d_generator_button_item_selected(index):
	match index:
		0: generatorChoice = dungeonType.RECT_CORRIDOR
		1: generatorChoice = dungeonType.DRUNKEN_WALK
		2: generatorChoice = dungeonType.PERLIN_NOISE
		3: generatorChoice = dungeonType.CELLULAR_AUTOMATA
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
		dungeonType.PERLIN_NOISE:
			var _frequency : float = float(inputOptionArray[0].inputField.text)
			var _fractal_octaves : int = int(inputOptionArray[1].inputField.text)
			var _fractal_lacunarity : float = float(inputOptionArray[2].inputField.text)
			var _fractal_gain : float = float(inputOptionArray[3].inputField.text)
			
			_dungeonGenerator = PerlinNoiseDungeonGenerator.new(_game_map, randi(), _frequency, _fractal_octaves, _fractal_lacunarity, _fractal_gain)
			_dungeonGenerator.genDungeon()
			bakeMap(_game_map)
		dungeonType.CELLULAR_AUTOMATA:
			var placement: float = float(inputOptionArray[0].inputField.text)
			var survival: int = int(inputOptionArray[1].inputField.text)
			var birth: int = int(inputOptionArray[2].inputField.text)
			var generations: int = int(inputOptionArray[2].inputField.text)
			
			_dungeonGenerator = CellularAutomataDungeonGenerator.new(_game_map, placement, survival, birth, generations)
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
		dungeonType.PERLIN_NOISE:
			clearOptionUI()
			handle_pn_generation()
		dungeonType.CELLULAR_AUTOMATA:
			clearOptionUI()
			handle_ca_generation()

func clearOptionUI():
	for option in inputOptionArray:
		option.call_deferred("queue_free")
	inputOptionArray.clear()

func handle_dw_generation():
	add_input_option("Walkers")
	add_input_option("Steps")

func handle_rc_generation():
	add_input_option("Max Rooms")
	add_input_option("Min Rooms")
	add_input_option("Max Room Width")
	add_input_option("Max Room Height")

func handle_pn_generation():
	add_input_option("Frequency", 1)
	add_input_option("Octaves")
	add_input_option("Lacunarity", 1)
	add_input_option("Gain", 1)

func handle_ca_generation():
	add_input_option("Placement", 1)
	add_input_option("Survival")
	add_input_option("Birth")
	add_input_option("Iterations")

# type 0 == int, type 1 == float
func add_input_option(_display_text: String, _data_type : int = 0):
	var option = inputOption.instantiate() as InputOption
	option.displayText.text = _display_text
	if _data_type == 1:
		option.inputField.placeholder_text = "/flt/"
	inputOptionContainer.add_child(option)
	inputOptionArray.append(option)

func _on_clear_entries_pressed():
	tileMap.clear()
	clearOptionUI()

func _on_generate_button_pressed():
	var valid: bool = true
	if inputOptionArray.size() == 0:
		showWarning("Pick a dungeon type to Generate.")
		return
	if (i_MAPHEIGHT_FIELD.text == "" or i_MAPWIDTH_FIELD.text == ""):
		valid = false
	for option in inputOptionArray:
		if option.inputField.text == "": valid = false
	if valid: 
		generate()
		return
	showWarning("Not all fields filled out!")
	return

func showWarning(warningText: String):
	warningLabel.text = warningText
	warningPanel.visible = true
	await get_tree().create_timer(2).timeout
	warningPanel.visible = false

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
