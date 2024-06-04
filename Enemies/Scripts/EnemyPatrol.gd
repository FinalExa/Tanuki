class_name EnemyPatrol
extends Node

@export var enemyController: EnemyController
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
	loadedPatrolIndicator = enemyController.patrolIndicators[0]
	set_current_patrol_routine()

func set_current_patrol_routine():
	if(enemyController.isInPatrol == true):
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
	enemyController.enemyMovement.set_location_target(target.global_position)
	enemyController.enemyMovement.reset_movement_speed()
	enemyController.enemyRotator.setLookingAtPosition(target.global_position)
	patrolMovementIndex = set_new_index(patrolMovementIndex, 1, loadedPatrolIndicator.moveActions.size())

func wait_patrol_action(timer):
	waitTimer = timer
	enemyController.enemyMovement.set_new_target(null)
	enemyController.enemyRotator.stopLooking()
	isWaiting = true
	patrolWaitIndex = set_new_index(patrolWaitIndex, 1, loadedPatrolIndicator.waitActions.size())

func look_around_patrol_action(rotationPoint):
	enemyController.enemyMovement.set_new_target(null)
	enemyController.enemyRotator.stopLooking()
	enemyController.enemyRotator.rotateTo(rotationPoint)
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
	enemyController.isInPatrol = false
	patrolStopped = true
	isRotating = false
	enemyController.enemyMovement.set_new_target(null)

func restart_patrol():
	enemyController.isInPatrol = true
	patrolStopped = false
	isRotating = false
	enemyController.enemyMovement.reset_movement_speed()
	reset_patrol()
	set_current_patrol_routine()

func resume_patrol():
	var backToMove: bool = false
	backToMove = resume_patrol_operation()
	while (!backToMove):
		backToMove = resume_patrol_operation()
	enemyController.isInPatrol = true
	patrolStopped = false
	isRotating = false
	enemyController.enemyMovement.reset_movement_speed()
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
	if (enemyController.isInPatrol == true):
		stop_patrol()
		enemyController.enemyStunned.start_stun(direction)

func initialize_startup():
	startupTimer = startupDuration
	startupActive = true

func select_new_patrol_indicator():
	if (enemyController.patrolIndicators.size() > 1):
		var storedIndex: int = 0
		var storedDistance: float
		var tempDistance: float
		for i in enemyController.patrolIndicators.size():
			if (i == 0):
				storedDistance = enemyController.global_position.distance_to(enemyController.patrolIndicators[i].global_position)
			else:
				tempDistance = enemyController.global_position.distance_to(enemyController.patrolIndicators[i].global_position)
				if (tempDistance < storedDistance):
					storedDistance = tempDistance
					storedIndex = i
		if (loadedPatrolIndicator != enemyController.patrolIndicators[storedIndex]):
			loadedPatrolIndicator = enemyController.patrolIndicators[storedIndex]
			reset_patrol()
		if (storedIndex != 0):
			extraPatrolTimer = timeSpentDoingExtraPatrol
