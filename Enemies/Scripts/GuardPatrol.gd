class_name GuardPatrol
extends Node

@export var guardController: GuardController
@export var guardMovement: GuardMovement
@export var guardRotator: GuardRotator
@export var guardStunned: GuardStunned
@export var startupDuration: float
var startupTimer: float
var startupActive: bool

var isWaiting: bool
var hasRotated: bool
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
				hasRotated = true
		patrolIndex = set_new_index(patrolIndex, 1, loadedPatrolIndicator.patrolActions.size())
		if (hasRotated == true):
			hasRotated = false
			set_current_patrol_routine()

func move_patrol_action(target):
	guardMovement.set_new_target(target)
	guardRotator.setLookingAtNode(target)
	patrolMovementIndex = set_new_index(patrolMovementIndex, 1, loadedPatrolIndicator.moveActions.size())

func wait_patrol_action(timer):
	waitTimer = timer
	guardMovement.set_new_target(null)
	guardRotator.stopLooking()
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
	guardRotator.stopLooking()
	guardRotator.rotateTo(rotationPoint)
	patrolLookAroundIndex = set_new_index(patrolLookAroundIndex, 1, loadedPatrolIndicator.lookActions.size())

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

func _on_guard_movement_reached_destination():
	set_current_patrol_routine()

func stop_patrol():
	guardController.isInPatrol = false
	patrolStopped = true
	guardMovement.set_location_target(guardController.global_position)

func restart_patrol():
	guardController.isInPatrol = true
	patrolStopped = false
	guardMovement.reset_movement_speed()
	reset_patrol()
	set_current_patrol_routine()

func resume_patrol():
	var backToMove: bool = false
	backToMove = resume_patrol_operation()
	while (!backToMove):
		backToMove = resume_patrol_operation()
	guardController.isInPatrol = true
	patrolStopped = false
	guardMovement.reset_movement_speed()
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

func _on_guard_damaged():
	if (guardController.isInPatrol == true):
		stop_patrol()
		guardStunned.start_stun()

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
		loadedPatrolIndicator = guardController.patrolIndicators[storedIndex]
		reset_patrol()
