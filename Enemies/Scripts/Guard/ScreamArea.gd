class_name ScreamArea
extends Area2D

var controllerRef: GuardController
@export var collisionShapeRef: CollisionShape2D
@export var maxAreaSize: float
@export var reducedAreaSize: float

func _ready():
	SetMaxAreaSize()

func SetReducedAreaSize():
	SetAreaSize(reducedAreaSize)

func SetMaxAreaSize():
	SetAreaSize(maxAreaSize)

func SetAreaSize(areaSize):
	collisionShapeRef.shape.radius = areaSize

func set_controller_ref(receivedRef: GuardController):
	controllerRef = receivedRef

func _on_body_entered(body):
	if (controllerRef != null && body != controllerRef && body is GuardController):
		var controller: GuardController = body
		if (!controller.isInAlert && !controller.isStunned):
			controller.guardCheck.stop_guardCheck()
			controller.guardAlert.start_alert(controllerRef.guardAlert.alertTarget)
