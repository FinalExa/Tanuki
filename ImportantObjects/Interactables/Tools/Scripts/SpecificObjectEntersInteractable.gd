class_name SpecificObjectEntersInteractable
extends Area2D

@export var interactableToOperate: GenericInteractable
@export var objectThatActivatesInteractable: Node2D
@export var launchOnce: bool
var launched: bool
var objectIn: bool

func _process(_delta):
	ExecuteEffect()

func _on_body_entered(body):
	if (interactableToOperate != null && objectThatActivatesInteractable != null && body == objectThatActivatesInteractable):
		objectIn = true

func _on_body_exited(body):
	if (interactableToOperate != null && objectThatActivatesInteractable != null && body == objectThatActivatesInteractable):
		objectIn = false

func _on_area_entered(area):
	if (interactableToOperate != null && objectThatActivatesInteractable != null && area == objectThatActivatesInteractable):
		objectIn = true

func _on_area_exited(area):
	if (interactableToOperate != null && objectThatActivatesInteractable != null && area == objectThatActivatesInteractable):
		objectIn = false

func ExecuteEffect():
	if (interactableToOperate != null && objectThatActivatesInteractable != null && objectIn && interactableToOperate.visible && ((launchOnce && !launched) || (!launchOnce))):
		if (launchOnce):
			launched = true
		interactableToOperate.ExecuteExtraEffect()
		interactableToOperate.FinalState()
