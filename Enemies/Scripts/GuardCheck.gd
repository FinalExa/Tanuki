class_name GuardCheck
extends Area2D

@export var controllerRef: GuardController
@export var maxAlertValue: float
@export var researchValueThreshold: float
@export var playerIsSeenMultiplier: float
@export var playerIsNotSeenMultiplier: float
@export var reductionOverTimeValue: float
@export var distanceMultiplier: float
@export var preCheckDuration: float
@export var rayTargets: Array[Node2D]
var checkTarget: Node2D
var currentAlertValue: float
var checkWithRayCast: bool
var preCheckActive: bool
var preCheckTimer: float
var reductionOverTimeActive: bool

@export var guardController: GuardController
@export var guardAlertValue: GuardAlertValue
@export var guardPatrol: GuardPatrol

func _ready():
	reset_alert_value()
	send_alert_value()

func _process(delta):
	reduction_over_time(delta)

func _physics_process(delta):
	check_for_player_with_raycast(delta)

func reset_alert_value():
	currentAlertValue = 0
	controllerRef.isChecking = false

func send_alert_value():
	guardAlertValue.updateValue(currentAlertValue, maxAlertValue)

func reduction_over_time(delta):
	if (reductionOverTimeActive == true):
		if (currentAlertValue > 0):
			currentAlertValue = clamp(currentAlertValue - (delta * reductionOverTimeValue), 0, maxAlertValue)
			send_alert_value()
		else:
			end_check()

func check_for_player_with_raycast(delta):
	if (checkWithRayCast == true):
		var space_state = get_world_2d().direct_space_state
		for i in rayTargets.size():
			var direction: Vector2 = rayTargets[i].position - controllerRef.position
			direction = direction.normalized()
			var query = PhysicsRayQueryParameters2D.create(controllerRef.position, rayTargets[i].global_position)
			var result = space_state.intersect_ray(query)
			if (result && result != { } && (result.collider == controllerRef.characterRef || result.collider == controllerRef.characterRef.tailRef)):
				determine_suspicion_type(result.collider, delta)
				break

func determine_suspicion_type(target, delta):
	player_or_tail_suspicion_type(target, delta)

func player_or_tail_suspicion_type(target, delta):
	if (target == controllerRef.characterRef):
		if(target.transformationChangeRef.isTransformed == false):
			suspicion_active(target, delta, playerIsSeenMultiplier)
		else:
			if (target.velocity != Vector2.ZERO):
				suspicion_active(target, delta, playerIsNotSeenMultiplier)
			else:
				var localAllowRef: LocalAllowedItems = target.transformationChangeRef.localAllowedItemsRef
				if (localAllowRef == null || (localAllowRef != null && !localAllowRef.allowedObjects.has(target.transformationChangeRef.currentTransformationName))):
					suspicion_active(target, delta, playerIsNotSeenMultiplier)
	else:
		if (target == controllerRef.characterRef.tailRef):
			suspicion_active(target, delta, playerIsSeenMultiplier)

func _on_body_entered(body):
	if (body == controllerRef.characterRef || body == controllerRef.characterRef.tailRef):
		checkWithRayCast = true

func _on_body_exited(body):
	if (body == controllerRef.characterRef || body == controllerRef.characterRef.tailRef):
		determine_if_end_check()

func suspicion_active(target: Node2D, delta, multiplier):
	if (reductionOverTimeActive == true):
		reductionOverTimeActive = false
	if (preCheckActive == false && guardController.isChecking == false):
		activate_precheck()
	else:
		if (preCheckActive == true && guardController.isChecking == false):
			execute_precheck(target, delta)
		else:
			if (preCheckActive == false && guardController.isChecking == true):
				increase_suspicion_value(delta, multiplier)

func activate_precheck():
	preCheckActive = true
	preCheckTimer = preCheckDuration

func execute_precheck(target: Node2D, delta):
	if (preCheckTimer>0):
		preCheckTimer -= delta
	else:
		activate_check(target)

func determine_if_end_check():
	if (guardController.isChecking == false):
		checkWithRayCast = false
		preCheckActive = false
	else:
		if (reductionOverTimeActive == false):
			activate_reduction_over_time()

func activate_reduction_over_time():
	reductionOverTimeActive = true

func activate_check(target: Node2D):
	preCheckActive = false
	guardController.isChecking = true
	guardPatrol.stop_patrol()
	checkTarget = target

func increase_suspicion_value(delta, multiplier):
	var distance: float = guardController.position.distance_to(checkTarget.position)
	var multValue: float = (abs(distance-(rayTargets[0].global_position.distance_to(guardController.position))))
	if (currentAlertValue < maxAlertValue):
		currentAlertValue = clamp(currentAlertValue + (multValue * distanceMultiplier * multiplier * delta), 0, maxAlertValue)
		send_alert_value()
	else:
		print("reached max alert value")

func end_check():
	reductionOverTimeActive = false
	guardController.isChecking = false
	guardPatrol.resume_patrol()
