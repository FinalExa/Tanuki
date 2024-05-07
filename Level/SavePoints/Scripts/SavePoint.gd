class_name SavePoint
extends Area2D

var sceneMasterRef: SceneMaster
var playerRef: PlayerCharacter

func _ready():
	sceneMasterRef = get_tree().root.get_child(0)

func activate_effect():
	sceneMasterRef.Save()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		body.set_save_point(self)
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		unset_player()

func unset_player():
	playerRef.unset_save_point()
	playerRef = null
