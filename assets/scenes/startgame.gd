extends Button


func _on_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/game_map.tscn")
