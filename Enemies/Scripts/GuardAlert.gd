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
var alertAreaFeedbackInstance: Node2D
var screamAreaInstance: ScreamArea
var catchPreparationTimer: float
var targetNotSeenTimer: float
var preChaseTimer: float
var catchPreparationActive: bool
var targetNotSeenActive: bool
var chaseStart: bool
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
	setup_areas()
	guardController.enemyMovement.SetAlertSound()

func _physics_process(_delta):
	alert_raycasts()

func start_alert(target):
	guardController.enemyStatus.updateText(alertText)
	alertTarget = target
	preChaseTimer = preChaseDuration
	call_deferred("add_area")
	call_deferred("add_feedback")
	chaseStart = false
	guardController.enemyMovement.set_location_target(guardController.global_position)
	targetNotSeenActive = false
	firstLocationReached = false
	secondLocationReached = false
	secondLocationTargetCheckLaunched = false
	lostSightOfPlayer = false
	guardController.isInAlert = true

func alert_raycasts():
	if (guardController.isInAlert):
		var space_state = guardController.get_world_2d().direct_space_state
		main_alert_raycast(space_state)
		if (secondLocationTargetCheckLaunched && !extraLocationSet):
			extraTargetLocation = set_possible_second_destination(space_state)

func main_alert_raycast(space_state):
		raycastResult.clear()
		for i in rayTargets.size():
			var query = PhysicsRayQueryParameters2D.create(guardController.global_position, rayTargets[i].global_position)
			var result = space_state.intersect_ray(query)
			if (result && result != { }): 
				raycastResult.push_back(result.collider)
			else:
				raycastResult.push_back(null)

func set_possible_second_destination(space_state):
		var searchPosition: Vector2 = guardController.global_position + (lastTargetDirection * searchForMissingTargetDistance)
		var query = PhysicsRayQueryParameters2D.create(guardController.global_position, searchPosition)
		var result = space_state.intersect_ray(query)
		extraLocationSet = true
		if (result && result != { }):
				return result.position
		return searchPosition

func set_last_target_info(receivedTarget: Node2D):
	lastTargetPosition = receivedTarget.global_position
	lastTargetDirection = receivedTarget.velocity

func set_movement_destination(destination: Vector2):
	guardController.enemyMovement.reset_movement_speed()
	guardController.enemyMovement.set_location_target(destination)
	guardController.enemyRotator.setLookingAtPosition(destination)

func start_not_seen_timer():
	targetNotSeenTimer = targetNotSeenDuration
	targetNotSeenActive = true

func start_catch_preparation():
	catchPreparationTimer = catchPreparationDuration
	catchPreparationActive = true

func capture_player():
	guardController.enemyMovement.set_new_target(null)
	guardController.enemyAttack.launch_attack()

func stop_alert():
	guardController.isInAlert = false
	chaseStart = false
	remove_area()
	remove_feedback()
	guardController.enemyMovement.reset_movement_speed()
	guardController.enemyMovement.SetPatrolSound()

func _on_guard_damaged(direction: Vector2):
	if (guardController.isInAlert == true):
		stop_alert()
		guardController.enemyStunned.start_stun(direction)

func remove_area():
	if(screamAreaInstance != null):
		remove_child(screamAreaInstance)
		screamAreaInstance = null

func remove_feedback():
	if (alertAreaFeedbackInstance != null):
		remove_child(alertAreaFeedbackInstance)
		alertAreaFeedbackInstance = null

func add_area():
	add_child(screamArea)
	for i in get_child_count():
		if (get_child(i) == screamArea):
			screamAreaInstance = get_child(i)
			break
	screamAreaInstance.set_controller_ref(guardController)

func add_feedback():
	add_child(alertAreaFeedback)
	for i in get_child_count():
		if (get_child(i) == alertAreaFeedback):
			alertAreaFeedbackInstance = get_child(i)
			break

func setup_areas():
	screamAreaInstance = screamArea
	remove_area()
	alertAreaFeedbackInstance = alertAreaFeedback
	remove_feedback()
