extends StandardInactivePanel

@export var activeLevelPath: String
@export var playtestMapPath: String
@export var playerMapPath: String

func _on_play_test_map_button_button_up():
	call_deferred("SwapScenes", playtestMapPath)

func _on_player_map_button_button_up():
	call_deferred("SwapScenes", playerMapPath)

func _on_back_button_button_up():
	BackToPreviousPanel()

func SwapScenes(scenePathToGo: String):
	var rootRef = get_tree().root
	var menuRef =  rootRef.get_child(0)
	rootRef.remove_child(menuRef)
	var obj_scene = load(activeLevelPath)
	var sceneMaster: SceneMaster = obj_scene.instantiate()
	sceneMaster.sceneSelector.ChangeScene(scenePathToGo)
	rootRef.add_child(sceneMaster)
	sceneMaster.sceneSelector.ReloadScene()
	menuRef.queue_free()
