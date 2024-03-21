class_name GuardPatrol
extends Node

@export var guardController: GuardController
@export var startupDuration: float
@export var timeSpentDoingExtraPatrol: float
var extraPatrolTimer: float
var startupTimer: float
var startupActive: bool

var isWaiting: bool
var isRotating: bool
var patrolStopped: bool

var waitTimer: float
var loadedPatrolIndicator: PatrolIndicator

var patrolIndex = 0
var patrolWaitIndex = 0
var patrolMovementIndex = 0
var patrolLookAroundIndex = 0

func _ready():
	loadedPatrolIndicator = guardController.patrolIndicators[0]

func _process(delta):
	startup(delta)
	wait_active(delta)
	extra_patrol_timer(delta)
	wait_for_rotation()

func wait_for_rotation():
	if (isRotating):
		if (guardController.guardRotator.isDoneRotating == true):
			set_current_patrol_routine()
			isRotating = false

func set_current_patrol_routine():
	if(guardController.isInPatrol == true):
		var currentAction = loadedPatrolIndicator.patrolActions[patrolIndex]
		if (currentAction == loadedPatrolIndicator.ActionTypes.WAIT):
			wait_patrol_action(loadedPatrolIndicator.waitActions[patrolWaitIndex])
		else:
			if (currentAction == loadedPatrolIndicator.ActionTypes.MOVE):
				move_patrol_action(loadedPatrolIndicator.moveActions[patrolMovementIndex])
			else:
				look_around_patrol_action(loadedPatrolIndicator.lookActions[patrolLookAroundIndex])
		patrolIndex = set_new_index(patrolIndex, 1, loadedPatrolIndicator.patrolActions.size())

func move_patrol_action(target):
	guardController.guardMovement.set_location_target(target.global_position)
	guardController.guardRotator.setLookingAtPosition(target.global_position)
	patrolMovementIndex = set_new_index(patrolMovementIndex, 1, loadedPatrolIndicator.moveActions.size())

func wait_patrol_action(timer):
	waitTimer = timer
	guardController.guardMovement.set_new_target(null)
	guardController.guardRotator.stopLooking()
	isWaiting = true
	patrolWaitIndex = set_new_index(patrolWaitIndex, 1, loadedPatrolIndicator.waitActions.size())

func wait_active(delta):
	if (isWaiting == true && patrolStopped == false):
		if (waitTimer>0):
			waitTimer-=delta
		else:
			isWaiting = false
			set_current_patrol_routine()

func look_around_patrol_action(rotationPoint):
	guardController.guardMovement.set_new_target(null)
	guardController.guardRotator.stopLooking()
	guardController.guardRotator.rotateTo(rotationPoint)
	patrolLookAroundIndex = set_new_index(patrolLookAroundIndex, 1, loadedPatrolIndicator.lookActions.size())
	isRotating = true

func set_new_index(currentIndex: int, valueChange:int , size:int):
	currentIndex += valueChange
	if(currentIndex >= size):
		currentIndex = 0
	else:
		if (currentIndex < 0):
			currentIndex = size - 1
	return currentIndex
	
func reset_patrol():
	patrolIndex = 0
	patrolWaitIndex = 0
	patrolMovementIndex = 0
	patrolLookAroundIndex = 0
	isRotating = false

func _on_guard_movement_reached_destination():
	set_current_patrol_routine()

func stop_patrol():
	guardController.isInPatrol = false
	patrolStopped = true
	isRotating = false
	guardController.guardMovement.set_location_target(guardController.global_position)

func restart_patrol():
	guardController.isInPatrol = true
	patrolStopped = false
	isRotating = false
	guardController.guardMovement.reset_movement_speed()
	reset_patrol()
	set_current_patrol_routine()

func resume_patrol():
	var backToMove: bool = false
	backToMove = resume_patrol_operation()
	while (!backToMove):
		backToMove = resume_patrol_operation()
	guardController.isInPatrol = true
	patrolStopped = false
	isRotating = false
	guardController.guardMovement.reset_movement_speed()
	set_current_patrol_routine()

func resume_patrol_operation():
	patrolIndex = set_new_index(patrolIndex, -1, loadedPatrolIndicator.patrolActions.size())
	if (loadedPatrolIndicator.patrolActions[patrolIndex] == loadedPatrolIndicator.ActionTypes.MOVE):
		patrolMovementIndex = set_new_index(patrolMovementIndex, -1, loadedPatrolIndicator.moveActions.size())
		return true
	else:
		if (loadedPatrolIndicator.patrolActions[patrolIndex] == loadedPatrolIndicator.ActionTypes.WAIT):
			patrolWaitIndex = set_new_index(patrolWaitIndex, -1, loadedPatrolIndicator.waitActions.size())
		else:
			patrolLookAroundIndex = set_new_index(patrolLookAroundIndex, -1, loadedPatrolIndicator.lookActions.size())
	return false

func _on_guard_damaged(direction: Vector2):
	if (guardController.isInPatrol == true):
		stop_patrol()
		guardController.guardStunned.start_stun(direction)

func initialize_startup():
	startupTimer = startupDuration
	startupActive = true

func startup(delta):
	if (startupActive == true):
		if (startupTimer>0):
			startupTimer-=delta
		else:
			set_current_patrol_routine()
			startupActive = false

func select_new_patrol_indicator():
	if (guardController.patrolIndicators.size() > 1):
		var storedIndex: int = 0
		var storedDistance: float
		var tempDistance: float
		for i in guardController.patrolIndicators.size():
			if (i == 0):
				storedDistance = guardController.global_position.distance_to(guardController.patrolIndicators[i].global_position)
			else:
				tempDistance = guardController.global_position.distance_to(guardController.patrolIndicators[i].global_position)
				if (tempDistance < storedDistance):
					storedDistance = tempDistance
					storedIndex = i
		if (loadedPatrolIndicator != guardController.patrolIndicators[storedIndex]):
			loadedPatrolIndicator = guardController.patrolIndicators[storedIndex]
			reset_patrol()
		if (storedIndex != 0):
			extraPatrolTimer = timeSpentDoingExtraPatrol

func extra_patrol_timer(delta):
	if (guardController.patrolIndicators.size() > 1 && loadedPatrolIndicator != guardController.patrolIndicators[0]):
		if (extraPatrolTimer > 0):
			extraPatrolTimer-=delta
		else:
			loadedPatrolIndicator = guardController.patrolIndicators[0]
			reset_patrol()
