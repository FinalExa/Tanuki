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
	if (enemyController.startingIndex > 0):
		AdvanceIndexTo(enemyController.startingIndex)
	set_current_patrol_routine()

func set_current_patrol_routine():
	if (enemyController.isInPatrol):
		var currentAction: PatrolIndicator.ActionTypes  = loadedPatrolIndicator.patrolActions[patrolIndex]
		if (currentAction == loadedPatrolIndicator.ActionTypes.WAIT):
			Wait(loadedPatrolIndicator.waitActions[patrolWaitIndex])
		else:
			if (currentAction == loadedPatrolIndicator.ActionTypes.MOVE):
				Move(loadedPatrolIndicator.moveActions[patrolMovementIndex])
			else:
				LookAround(loadedPatrolIndicator.lookActions[patrolLookAroundIndex])
		patrolIndex = set_new_index(patrolIndex, 1, loadedPatrolIndicator.patrolActions.size())

func Move(target):
	enemyController.enemyMovement.set_location_target(target.global_position)
	enemyController.enemyMovement.reset_movement_speed()
	enemyController.enemyRotator.setLookingAtPosition(target.global_position)
	patrolMovementIndex = set_new_index(patrolMovementIndex, 1, loadedPatrolIndicator.moveActions.size())

func Wait(timer):
	waitTimer = timer
	enemyController.enemyMovement.set_new_target(null)
	enemyController.enemyRotator.stopLooking()
	isWaiting = true
	patrolWaitIndex = set_new_index(patrolWaitIndex, 1, loadedPatrolIndicator.waitActions.size())

func LookAround(rotationPoint):
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
	AdvanceIndexTo(GetClosestMovementLocation())
	enemyController.isInPatrol = true
	patrolStopped = false
	isRotating = false
	enemyController.enemyMovement.reset_movement_speed()
	set_current_patrol_routine()

func GetClosestMovementLocation():
	var moveIndex: int = 0
	var selectedIndex: int = 0
	var selectedMoveIndex: int = 0
	var firstMoveSet: bool = false
	var distanceToSelectedIndex: float
	for i in loadedPatrolIndicator.patrolActions.size():
		var currentAction: PatrolIndicator.ActionTypes = loadedPatrolIndicator.patrolActions[i]
		if (currentAction == PatrolIndicator.ActionTypes.MOVE):
			if (!firstMoveSet):
				selectedIndex = i
				firstMoveSet = true
				distanceToSelectedIndex = enemyController.global_position.distance_to(loadedPatrolIndicator.moveActions[selectedMoveIndex].global_position)
			else:
				if (moveIndex < loadedPatrolIndicator.moveActions.size()):
					var distanceToNewIndex: float = enemyController.global_position.distance_to(loadedPatrolIndicator.moveActions[moveIndex].global_position)
					if (distanceToNewIndex < distanceToSelectedIndex):
						selectedIndex = i
						selectedMoveIndex = moveIndex
						distanceToSelectedIndex = distanceToNewIndex
			moveIndex += 1
	return selectedIndex

func _on_enemy_damaged(direction: Vector2, tier: EnemyStunned.StunTier):
	if (enemyController.isInPatrol):
		stop_patrol()
		enemyController.enemyStunned.start_stun(direction, tier)

func OnEnemyRepelled():
	if (enemyController.isInPatrol):
		stop_patrol()

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

func AdvanceIndexTo(targetIndex: int):
	patrolIndex = 0
	patrolMovementIndex = 0
	patrolWaitIndex = 0
	patrolLookAroundIndex = 0
	for i in targetIndex:
		var currentAction: PatrolIndicator.ActionTypes = loadedPatrolIndicator.patrolActions[patrolIndex]
		if (currentAction == PatrolIndicator.ActionTypes.MOVE):
			patrolMovementIndex = set_new_index(patrolMovementIndex, 1, loadedPatrolIndicator.moveActions.size())
		else:
			if (currentAction == PatrolIndicator.ActionTypes.WAIT):
				patrolWaitIndex = set_new_index(patrolWaitIndex, 1, loadedPatrolIndicator.waitActions.size())
			else:
				if (currentAction == PatrolIndicator.ActionTypes.LOOK_AROUND):
					patrolLookAroundIndex = set_new_index(patrolLookAroundIndex, 1, loadedPatrolIndicator.lookActions.size())
		patrolIndex = set_new_index(patrolIndex, 1, loadedPatrolIndicator.patrolActions.size())
