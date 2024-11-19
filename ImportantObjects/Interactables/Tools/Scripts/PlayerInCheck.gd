class_name PlayerInCheck
extends Area2D

@export var connectedInteractable: GenericInteractable

func _on_body_entered(body):
	if (body is PlayerCharacter):
		if (connectedInteractable != null): connectedInteractable.FinalState()
