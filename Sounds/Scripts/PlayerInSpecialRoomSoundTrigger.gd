extends Area2D


func _on_body_entered(body):
	if (body is PlayerCharacter):
		var gameplayScene: GameplayScene = get_tree().root.get_child(0).sceneSelector.currentScene
		gameplayScene.gameplaySceneSoundtrack.ActivateSpecialRoom()

func _on_body_exited(body):
	if (body is PlayerCharacter):
		var gameplayScene: GameplayScene = get_tree().root.get_child(0).sceneSelector.currentScene
		gameplayScene.gameplaySceneSoundtrack.DeactivateSpecialRoom()
