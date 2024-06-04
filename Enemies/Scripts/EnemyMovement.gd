class_name EnemyMovement
extends Node

signal reached_destination

@export var enemyController: EnemyController
@export var navigationAgent: NavigationAgent2D

@export var defaultMovementSpeed: float
@export var distanceTolerance: float
@export var repathTimerDuration: float
@export var patrolMovementSound: AudioStreamPlayer2D
@export var alertMovementSound: AudioStreamPlayer2D
var currentMovementSound: AudioStreamPlayer2D
var repathTimer: float
var currentMovementSpeed: float
var target: Node2D
var locationTarget: Vector2
var locationTargetEnabled: bool

func _ready():
	repathTimer = 0
	currentMovementSpeed = defaultMovementSpeed
	SetPatrolSound()

func _update_navigation_path(end_position):
	navigationAgent.target_position = end_position

func _process(_delta):
	PlayMovementSound()

func _physics_process(delta):
	if((target != null || locationTargetEnabled)):
		navigation(delta)
		navigate_on_path()

func navigate_on_path():
	var movementSpeed = currentMovementSpeed
	var dir = enemyController.global_position.direction_to(navigationAgent.get_next_path_position())
	enemyController.velocity = dir * movementSpeed
	enemyController.move_and_slide()
	if ((locationTargetEnabled && enemyController.global_position.distance_to(locationTarget) < distanceTolerance)
	|| (target != null && enemyController.global_position.distance_to(target.global_position) < distanceTolerance)):
		currentMovementSpeed = 0
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
			_update_navigation_path(enemyController.global_position)

func set_movement_speed(newMovementSpeed: float):
	currentMovementSpeed = newMovementSpeed

func reset_movement_speed():
	currentMovementSpeed = defaultMovementSpeed

func PlayMovementSound():
	if (enemyController.velocity != Vector2.ZERO):
		if (!currentMovementSound.playing):
			currentMovementSound.play()
	else:
		currentMovementSound.stop()

func SetPatrolSound():
	if (currentMovementSound != null && currentMovementSound.playing):
		currentMovementSound.stop()
	currentMovementSound = patrolMovementSound

func SetAlertSound():
	if (currentMovementSound != null && currentMovementSound.playing):
		currentMovementSound.stop()
	currentMovementSound = alertMovementSound