class_name GuardMovement
extends Node

signal reached_destination

@export var guardController: GuardController
@export var bodyRef: CharacterBody2D
@export var navigationAgent: NavigationAgent2D

@export var defaultMovementSpeed: float
@export var distanceTolerance: float
@export var repathTimerDuration: float
var repathTimer: float
var currentMovementSpeed
var target: Node2D
var locationTarget: Vector2
var locationTargetEnabled: bool

func _ready():
	repathTimer = 0
	currentMovementSpeed = defaultMovementSpeed

func _update_navigation_path(end_position):
	navigationAgent.target_position = end_position

func _physics_process(delta):
	if((target != null || locationTargetEnabled)):
		navigation(delta)
		navigate_on_path()

func navigate_on_path():
	var movementSpeed = currentMovementSpeed
	var dir = guardController.global_position.direction_to(navigationAgent.get_next_path_position())
	guardController.velocity = dir * movementSpeed
	guardController.move_and_slide()
	if ((locationTargetEnabled && guardController.global_position.distance_to(locationTarget) < distanceTolerance)
	|| (target != null && guardController.global_position.distance_to(target.global_position) < distanceTolerance)):
		emit_signal("reached_destination")

func set_new_target(newTarget):
	target = newTarget
	locationTarget = Vector2.ZERO
	locationTargetEnabled = false
	repath()

func set_location_target(locTarget: Vector2):
	locationTarget = locTarget
	target = null
	locationTargetEnabled = true
	repath()

func navigation(delta):
	if (repathTimer>0):
		repathTimer-=delta
	else:
		repath()
		repathTimer = repathTimerDuration

func repath():
	if(target != null):
		_update_navigation_path(target.global_position)
	else:
		if (locationTargetEnabled):
			_update_navigation_path(locationTarget)
		else:
			_update_navigation_path(bodyRef.global_position)

func set_movement_speed(newMovementSpeed: float):
	currentMovementSpeed = newMovementSpeed

func reset_movement_speed():
	currentMovementSpeed = defaultMovementSpeed
