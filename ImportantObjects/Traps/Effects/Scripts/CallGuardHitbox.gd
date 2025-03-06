class_name CallGuardHitbox
extends Area2D

var targetObject: PlayerCharacter
var activated: bool
var guardsInRange: Array[GuardController]

func _ready():
	SetInactive()

func _process(_delta):
	CallOtherGuards()

func SetActive():
	self.show()
	activated = true

func SetInactive():
	self.hide()
	activated = false

func CallOtherGuards():
	if (activated && targetObject != null):
		for i in guardsInRange.size():
			GuardLaunchAlert(guardsInRange[i])

func GuardLaunchAlert(guardRef: GuardController):
	if (!guardRef.isInAlert && !guardRef.isStunned):
		if (guardRef.isInPatrol):
			guardRef.enemyPatrol.stop_patrol()
		if (guardRef.isChecking):
			guardRef.guardCheck.stop_guardCheck()
		if (guardRef.isInResearch):
			guardRef.guardResearch.StopResearch()
		guardRef.guardAlert.start_alert(targetObject)
		guardRef.guardAlert.SetAlertTargetLastInfo(targetObject)

func _on_body_entered(body):
	if (body is PlayerCharacter && targetObject == null):
		targetObject = body
		return
	if (body is GuardController && !guardsInRange.has(body)):
		guardsInRange.push_back(body)

func _on_body_exited(body):
	if (body is PlayerCharacter && targetObject == body):
		targetObject = null
		return
	if (body is GuardController && guardsInRange.has(body)):
		guardsInRange.erase(body)
