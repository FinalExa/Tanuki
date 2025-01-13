class_name ScreamArea
extends Area2D

var controllerRef: GuardController
var guardsInRange: Array[GuardController]
var activated: bool
@export var collisionShapeRef: CollisionShape2D
@export var maxAreaSize: float
@export var reducedAreaSize: float

func _ready():
	SetInactive()
	SetMaxAreaSize()

func _process(_delta):
	LaunchAlertForGuardsInRange()

func SetReducedAreaSize():
	SetAreaSize(reducedAreaSize)

func SetMaxAreaSize():
	SetAreaSize(maxAreaSize)

func SetAreaSize(areaSize):
	collisionShapeRef.shape.radius = areaSize

func SetControllerRef(receivedRef: GuardController):
	controllerRef = receivedRef

func SetActive():
	self.show()
	activated = true

func SetInactive():
	self.hide()
	activated = false

func LaunchAlertForGuardsInRange():
	if (activated):
		for i in guardsInRange.size():
			if (!guardsInRange[i].guardAlert.lostSightOfPlayer):
				LaunchGuardAlert(guardsInRange[i])
				UpdateWithLatestPosition(guardsInRange[i])

func LaunchGuardAlert(guardRef: GuardController):
	if (!guardRef.isInAlert && !guardRef.isStunned):
		guardRef.guardCheck.stop_guardCheck()
		guardRef.guardAlert.start_alert(controllerRef.guardAlert.alertTarget)

func UpdateWithLatestPosition(guardRef: GuardController):
	if (guardRef.isInAlert && controllerRef.guardAlert.alertTarget.transformationChangeRef.get_if_transformed_in_right_zone() != 1):
		guardRef.guardAlert.goToAlertStartLocation = true
		guardRef.guardAlert.SetAlertTargetLastInfo(controllerRef.guardAlert.alertTarget)

func _on_body_entered(body):
	if (controllerRef != null && body != controllerRef && body is GuardController && !guardsInRange.has(body)):
		guardsInRange.push_back(body)

func _on_body_exited(body):
	if (body is GuardController && guardsInRange.has(body)):
		guardsInRange.erase(body)
