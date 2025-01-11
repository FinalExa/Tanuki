extends GuardNode

@export var guardAlert: GuardAlert
var guardController: GuardController

func _ready():
	guardController = enemyController

func Evaluate(_delta):
	TargetNotSeen()
	return NodeState.SUCCESS

func TargetNotSeen():
	guardAlert.catchPreparationActive = false
	guardAlert.lostSightOfPlayer = true
	if (!guardAlert.firstLocationReached):
		MoveToFirstLocation()
		return
	if (!guardAlert.secondLocationReached):
		MoveToSecondLocation()
		return
	if (!guardAlert.targetNotSeenActive):
		StartNotSeenTimer()

func MoveToFirstLocation():
	var distance: float = enemyController.global_position.distance_to(guardAlert.lastTargetPosition)
	if (distance > guardAlert.targetNotSeenLastLocationThreshold && guardAlert.chaseStart):
		SetNotSeenDestination(guardAlert.lastTargetPosition)
	else:
		guardAlert.firstLocationReached = true

func MoveToSecondLocation():
	if (guardAlert.secondLocationTargetCheckLaunched == false):
		guardAlert.secondLocationTargetCheckLaunched = true
		guardAlert.extraLocationSet = false
	var extraDistance: float = enemyController.global_position.distance_to(guardAlert.extraTargetLocation)
	if (extraDistance > guardAlert.targetNotSeenLastLocationThreshold && guardAlert.chaseStart):
		SetNotSeenDestination(guardAlert.extraTargetLocation)
	else:
		guardAlert.secondLocationReached = true
		StopGuardMovement()

func StartNotSeenTimer():
	guardAlert.targetNotSeenTimer = guardAlert.targetNotSeenDuration
	guardAlert.targetNotSeenActive = true

func SetNotSeenDestination(destination: Vector2):
	guardController.enemyMovement.set_movement_speed(guardAlert.alertMovementSpeed)
	guardController.enemyMovement.set_location_target(destination)
	guardController.enemyRotator.setLookingAtPosition(destination)

func StopGuardMovement():
	guardController.enemyMovement.set_new_target(null)
	guardController.enemyRotator.setLookingAtNode(null)
