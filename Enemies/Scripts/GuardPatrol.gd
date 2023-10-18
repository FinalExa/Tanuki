extends Node

@export var guardController: GuardController
@export var guardMovement: GuardMovement

@export var isInPatrol: bool
var isWaiting: bool

var waitTimer: float

var patrolIndex = 0
var patrolWaitIndex = 0
var patrolMovementIndex = 0
var patrolLookAroundIndex = 0

func _ready():
	set_current_patrol_routine()

func _process(delta):
	wait_active(delta)

func set_current_patrol_routine():
	print("called")
	var currentAction = guardController.patrolActions[patrolIndex]
	if (currentAction == guardController.ActionTypes.WAIT):
		wait_patrol_action(guardController.waitActions[patrolWaitIndex])
	else:
		if (currentAction == guardController.ActionTypes.MOVE):
			move_patrol_action(guardController.moveActions[patrolMovementIndex])
		else:
			print("look around")
	set_new_index(patrolIndex, guardController.patrolActions.size())

func move_patrol_action(target):
	guardMovement.set_new_target(target)
	patrolMovementIndex = set_new_index(patrolMovementIndex, guardController.moveActions.size())

func wait_patrol_action(timer):
	waitTimer = timer
	guardMovement.set_new_target(null)
	isWaiting = true
	patrolWaitIndex = set_new_index(patrolWaitIndex, guardController.waitActions.size())

func wait_active(delta):
	if (isWaiting == true):
		if (waitTimer>0):
			waitTimer-=delta
		else:
			isWaiting = false
			set_current_patrol_routine()

func set_new_index(index, size):
	index += 1
	if(index>=size):
		index = 0
	return index

func go_to_next_patrol_routine():
	pass
	
func reset_patrol():
	pass

func _on_guard_movement_reached_destination():
	if(isInPatrol == true):
		go_to_next_patrol_routine()
