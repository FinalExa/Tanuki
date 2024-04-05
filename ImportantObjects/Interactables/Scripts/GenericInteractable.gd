class_name GenericInteractable
extends Node2D

@export var neededString: String

func attackInteraction(receivedString):
	if (neededString == receivedString):
		ExecuteExtraEffect()
		get_parent().remove_child(self)

func ExecuteExtraEffect():
	pass
