class_name GuardAlert
extends Node2D

@export var alertMovementSpeed: float
@export var catchDistanceThreshold: float
@export var catchPreparationDuration: float
@export var targetNotSeenDuration: float
@export var targetNotSeenLastLocationThreshold: float
@export var preChaseDuration: float
@export var searchForMissingTargetDistance: float
@export var rayTargets: Array[Node2D]
@export var alertText: String
@export var screamArea: ScreamArea
@export var returnToCheckAlertValue: float
@export var alertAreaFeedback: Node2D
@export var alertStartSound: AudioStreamPlayer2D
var catchPreparationTimer: float
var targetNotSeenTimer: float
var preChaseTimer: float
var catchPreparationActive: bool
var targetNotSeenActive: bool
var chaseStart: bool
var goToAlertStartLocation: bool
var firstLocationReached: bool
var secondLocationReached: bool
var secondLocationTargetCheckLaunched: bool
var lostSightOfPlayer: bool
var alertTarget: Node2D
var lastTargetPosition: Vector2
var lastTargetDirection: Vector2
var extraTargetLocation: Vector2
var raycastResult: Array[Node2D]
var extraLocationSet: bool

@export var guardController: GuardController

func _ready():
	RemoveAreas()

func _physics_process(_delta):
	AlertRaycasts()

func start_alert(target):
	guardController.enemyStatus.updateText(alertText)
	alertTarget = target
	SetAlertTargetLastInfo(alertTarget)
	preChaseTimer = preChaseDuration
	call_deferred("AddAreas")
	chaseStart = false
	guardController.enemyMovement.set_new_target(null)
	guardController.enemyRotator.setLookingAtNode(alertTarget)
	goToAlertStartLocation = true
	targetNotSeenActive = false
	firstLocationReached = false
	secondLocationReached = false
	secondLocationTargetCheckLaunched = false
	lostSightOfPlayer = false
	guardController.isInAlert = true
	alertStartSound.play()

func AlertRaycasts():
	if (guardController.isInAlert):
		var space_state = guardController.get_world_2d().direct_space_state
		AlertRaycast(space_state)
		if (secondLocationTargetCheckLaunched && !extraLocationSet):
			extraTargetLocation = GetSecondDestination(space_state)

func AlertRaycast(space_state):
	raycastResult.clear()
	for i in rayTargets.size():
		var query = PhysicsRayQueryParameters2D.create(guardController.global_position, rayTargets[i].global_position)
		var result = space_state.intersect_ray(query)
		if (result && result != { }): 
			raycastResult.push_back(result.collider)
		else:
			raycastResult.push_back(null)

func GetSecondDestination(space_state):
	var searchPosition: Vector2 = guardController.global_position + (lastTargetDirection * searchForMissingTargetDistance)
	var query = PhysicsRayQueryParameters2D.create(guardController.global_position, searchPosition)
	var result = space_state.intersect_ray(query)
	extraLocationSet = true
	if (result && result != { }):
		return result.position
	return searchPosition

func SetAlertTargetLastInfo(receivedTarget: Node2D):
	lastTargetPosition = receivedTarget.global_position
	lastTargetDirection = receivedTarget.velocity

func stop_alert():
	guardController.isInAlert = false
	chaseStart = false
	RemoveAreas()
	guardController.enemyMovement.reset_movement_speed()

func _on_guard_damaged(direction: Vector2, tier: EnemyStunned.StunTier):
	if (guardController.isInAlert == true):
		stop_alert()
		guardController.enemyStunned.start_stun(direction, tier)

func OnGuardRepelled():
	if (guardController.isInAlert == true):
		stop_alert()

func RemoveAreas():
	screamArea.SetInactive()
	alertAreaFeedback.hide()

func AddAreas():
	screamArea.SetActive()
	screamArea.SetControllerRef(guardController)
	alertAreaFeedback.show()
