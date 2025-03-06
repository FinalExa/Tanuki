class_name WardenAlertArea
extends Area2D

var guardsInArea: Array[GuardController]
var activated: bool
@export var wardenCheck: WardenCheck
@export var wardenLocation: Node2D

func _physics_process(_delta):
	UpdatePlayerPositionToGuardsInArea()

func SetActive():
	self.show()
	activated = true

func SetInactive():
	self.hide()
	activated = false

func UpdatePlayerPositionToGuardsInArea():
	if (activated && wardenCheck.playerIn && guardsInArea.size() > 0):
		var space_state = wardenCheck.enemyController.get_world_2d().direct_space_state
		for i in guardsInArea.size():
			if (CallGuardRaycast(space_state, guardsInArea[i])):
				SetGuardInAlert(guardsInArea[i])
				UpdateGuardWithInfo(guardsInArea[i])

func CallGuardRaycast(space_state, currentGuard: GuardController):
	var query = PhysicsRayQueryParameters2D.create(currentGuard.global_position, wardenLocation.global_position)
	query.exclude = [currentGuard]
	var result = space_state.intersect_ray(query)
	if (result && result != { }):
		if (result.collider == wardenCheck.enemyController || result.collider is PlayerCharacter):
			return true
	return false

func UpdateGuardWithInfo(guard: GuardController):
	if (guard.isInAlert && guard.guardAlert.targetNotSeenActive):
		guard.guardAlert.goToAlertStartLocation = true
		guard.guardAlert.SetAlertTargetLastInfo(wardenCheck.playerRef)

func SetGuardInAlert(guard: GuardController):
	if (!guard.isInAlert && !guard.isStunned):
		if (guard.isInPatrol):
			guard.enemyPatrol.stop_patrol()
		if (guard.isChecking):
			guard.guardCheck.StopCheck()
		if (guard.isInResearch):
			guard.guardResearch.StopResearch()
		guard.guardAlert.start_alert(wardenCheck.playerRef)

func ClearGuardsInArea():
	guardsInArea.clear()

func _on_body_entered(body):
	if (body is GuardController && !guardsInArea.has(body)):
		guardsInArea.push_back(body)

func _on_body_exited(body):
	if (body is GuardController && guardsInArea.has(body)):
		guardsInArea.erase(body)
