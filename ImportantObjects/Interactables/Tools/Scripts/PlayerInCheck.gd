class_name PlayerInCheck
extends Area2D

@export var connectedInteractable: GenericInteractable

func _on_body_entered(body):
	if (connectedInteractable != null && body is PlayerCharacter):
		connectedInteractable.FinalState()
