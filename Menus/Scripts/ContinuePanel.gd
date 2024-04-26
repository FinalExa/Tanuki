extends StandardInactivePanel

@export var playtestMapPath: String
@export var playerMapPath: String

func _on_play_test_map_button_button_up():
	get_tree().change_scene_to_file(playtestMapPath)

func _on_player_map_button_button_up():
	get_tree().change_scene_to_file(playerMapPath)

func _on_back_button_button_up():
	BackToPreviousPanel()
