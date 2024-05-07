class_name SmallGapExitPoint
extends Area2D

@export var otherPoint: SmallGapExitPoint
var charactersInteractingWithPoint: Array[CharacterBody2D]

func _on_body_entered(body):
	if ((body is PlayerCharacter || body is GuardController) && !charactersInteractingWithPoint.has(body)):
		if (otherPoint.charactersInteractingWithPoint.has(body)): otherPoint.charactersInteractingWithPoint.erase(body)
		charactersInteractingWithPoint.push_back(body)
