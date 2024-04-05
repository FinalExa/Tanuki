class_name DeactivationButton
extends Area2D

@export var objectToDeactivate: Node2D
var activated: bool
var playerRef: PlayerCharacter

func activate_effect():
	if (!activated):
		objectToDeactivate.get_parent().remove_child(objectToDeactivate)
		activated = true
		unset_player()

func _on_body_entered(body):
	if (body is PlayerCharacter && !activated):
		body.set_deactivation_button(self)
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter && !activated):
		unset_player()

func unset_player():
	playerRef.unset_deactivation_button()
	playerRef = null
