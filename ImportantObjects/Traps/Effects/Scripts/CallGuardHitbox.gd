class_name CallGuardHitbox
extends Area2D

var targetObject: PlayerCharacter
var activated: bool
var guardsInRange: Array[GuardController]

func _ready():
	SetInactive()

func _process(delta):
	CallOtherGuards()

func SetActive():
	self.show()
	activated = true

func SetInactive():
	self.hide()
	activated = false

func _on_body_entered(body):
	if (body is GuardController):
		var guardRef: GuardController = body

func CallOtherGuards():
	if (activated):
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
		guardRef.guardAlert.set_movement_destination(targetObject.global_position)
