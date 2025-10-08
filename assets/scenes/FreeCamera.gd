extends CharacterBody2D

@export var speed: float = 800.0
@export var zoom_step: float = 0.1
@export var min_zoom: float = 0.25
@export var max_zoom: float = 4.0

@onready var cam: Camera2D = $Camera2D

func _ready() -> void:
	_ensure_input_actions()

func _physics_process(delta: float) -> void:
	var input_vec := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if input_vec.length_squared() > 1.0:
		input_vec = input_vec.normalized()

	velocity = input_vec * speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_set_zoom(cam.zoom.x * (1.0 - zoom_step))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_set_zoom(cam.zoom.x * (1.0 + zoom_step))

	# Optional keyboard zoom (Q/E)
	if event.is_action_pressed("zoom_in"):
		_set_zoom(cam.zoom.x * (1.0 - zoom_step))
	elif event.is_action_pressed("zoom_out"):
		_set_zoom(cam.zoom.x * (1.0 + zoom_step))

func _set_zoom(target: float) -> void:
	target = clamp(target, min_zoom, max_zoom)
	cam.zoom = Vector2(target, target)

func _ensure_input_actions() -> void:
	# Create actions at runtime if they don't already exist
	var a := [
		["move_up", KEY_W, KEY_UP],
		["move_down", KEY_S, KEY_DOWN],
		["move_left", KEY_A, KEY_LEFT],
		["move_right", KEY_D, KEY_RIGHT],
		["zoom_in", KEY_Q, -1],
		["zoom_out", KEY_E, -1],
	]
	for item in a:
		var name = item[0]
		if not InputMap.has_action(name):
			InputMap.add_action(name)
		var primary = item[1]
		var secondary = item[2]
		if primary != -1:
			var ev1 := InputEventKey.new()
			ev1.keycode = primary
			InputMap.action_add_event(name, ev1)
		if secondary != -1:
			var ev2 := InputEventKey.new()
			ev2.keycode = secondary
			InputMap.action_add_event(name, ev2)
