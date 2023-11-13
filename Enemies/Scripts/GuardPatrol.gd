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

var patrolIndex = 0
var patrolWaitIndex = 0
var patrolMovementIndex = 0
var patrolLookAroundIndex = 0

func _process(delta):
	startup(delta)
	wait_active(delta)

func set_current_patrol_routine():
	if(guardController.isInPatrol == true):
		var currentAction = guardController.patrolActions[patrolIndex]
		if (currentAction == guardController.ActionTypes.WAIT):
			wait_patrol_action(guardController.waitActions[patrolWaitIndex])
		else:
			if (currentAction == guardController.ActionTypes.MOVE):
				move_patrol_action(guardController.moveActions[patrolMovementIndex])
			else:
				look_around_patrol_action(guardController.lookActions[patrolLookAroundIndex])
				hasRotated = true
		patrolIndex = set_new_index(patrolIndex, guardController.patrolActions.size())
		if (hasRotated == true):
			hasRotated = false
			set_current_patrol_routine()

func move_patrol_action(target):
	guardMovement.set_new_target(target)
	guardRotator.setLookingAtNode(target)
	patrolMovementIndex = set_new_index(patrolMovementIndex, guardController.moveActions.size())

func wait_patrol_action(timer):
	waitTimer = timer
	guardMovement.set_new_target(null)
	guardRotator.stopLooking()
	isWaiting = true
	patrolWaitIndex = set_new_index(patrolWaitIndex, guardController.waitActions.size())

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
	patrolLookAroundIndex = set_new_index(patrolLookAroundIndex, guardController.lookActions.size())

func set_new_index(index, size):
	index += 1
	if(index >= size):
		index = 0
	else:
		if (index < 0):
			index = size
	return index
	
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
	set_new_index(-1, guardController.patrolActions.size())
	guardController.isInPatrol = true
	patrolStopped = false
	guardMovement.reset_movement_speed()

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
