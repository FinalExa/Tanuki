class_name ScreamArea
extends Area2D

var controllerRef: GuardController

func set_controller_ref(receivedRef: GuardController):
	controllerRef = receivedRef

func _on_body_entered(body):
	if (controllerRef != null && body != controllerRef && body is GuardController):
		var controller: GuardController = body
		if (!controller.isInAlert && !controller.isInResearch):
			controller.guardResearch.initialize_guard_research(controllerRef, true)
