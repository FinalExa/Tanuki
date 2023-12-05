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
var checkActive: bool
var checkTarget: Node2D
var currentAlertValue: float
var checkWithRayCast: bool
var preCheckActive: bool
var preCheckTimer: float
var reductionOverTimeActive: bool
var researchOutcome: bool
var bodySave: Node2D
var playerInsideCheckHitbox: bool
var playerSeen: bool

@export var guardRotator: GuardRotator
@export var guardController: GuardController
@export var guardAlertValue: GuardAlertValue
@export var guardResearch: GuardResearch
@export var guardAlert: GuardAlert
@export var guardPatrol: GuardPatrol
@export var guardStunned: GuardStunned
@export var guardMovement: GuardMovement

func _ready():
	reset_alert_value()
	send_alert_value()
	checkActive = true

func _process(delta):
	body_checks()

func _physics_process(delta):
	check_with_raycast(delta)

func reset_alert_value():
	currentAlertValue = 0
	controllerRef.isChecking = false

func send_alert_value():
	guardAlertValue.updateValue(currentAlertValue, maxAlertValue)

func check_with_raycast(delta):
	if (checkActive == true && checkWithRayCast == true):
		var space_state = get_world_2d().direct_space_state
		var seenPlayer: bool = false
		for i in rayTargets.size():
			var direction: Vector2 = rayTargets[i].position - controllerRef.position
			var query = PhysicsRayQueryParameters2D.create(controllerRef.position, rayTargets[i].global_position)
			var result = space_state.intersect_ray(query)
			if (result && result != { }):
				if(result.collider is PlayerCharacter || result.collider is TailFollow): 
					determine_suspicion_type_with_conditions(result.collider, delta)
					seenPlayer = true
				break
		playerSeen = seenPlayer

func determine_suspicion_type_with_conditions(target, delta):
	if(checkActive == true):
		determine_suspicion_type(target, delta)

func determine_suspicion_type(target, delta):
	if (target is PlayerCharacter):
		if(target.transformationChangeRef.isTransformed == false):
			playerSeen = true
			suspicion_active(target, delta, playerIsSeenMultiplier)
			researchOutcome = true
		else:
			if (target.velocity != Vector2.ZERO):
				suspicion_active(target, delta, playerIsNotSeenMultiplier)
				researchOutcome = false
			else:
				var localAllowRef: LocalAllowedItems = target.transformationChangeRef.localAllowedItemsRef
				if (localAllowRef == null || (localAllowRef != null && !localAllowRef.allowedObjects.has(target.transformationChangeRef.currentTransformationName))):
					suspicion_active(target, delta, playerIsNotSeenMultiplier)
					researchOutcome = false
				else:
					if (playerSeen):
						suspicion_active(target, delta, playerIsNotSeenMultiplier)
						researchOutcome = false
	else:
		if (target is TailFollow):
			suspicion_active(target, delta, playerIsSeenMultiplier)
			researchOutcome = true

func _on_body_entered(body):
	if (body is PlayerCharacter || body is TailFollow):
		playerInsideCheckHitbox = true
		bodySave = body

func _on_body_exited(body):
	if (body is PlayerCharacter || body is TailFollow):
		playerInsideCheckHitbox = false

func body_checks():
	if (checkActive):
		if (playerInsideCheckHitbox && !checkWithRayCast):
			checkWithRayCast = true
			return
		if (!playerInsideCheckHitbox):
				determine_if_end_check(bodySave)

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

func determine_if_end_check(_body):
	if (guardController.isChecking == false):
		checkWithRayCast = false
		preCheckActive = false
	else:
		if (currentAlertValue >= researchValueThreshold):
			stop_guardCheck()
			guardResearch.initialize_guard_research(checkTarget)
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
	if (checkTarget != null):
		var distance: float = guardController.position.distance_to(checkTarget.position)
		var multValue: float = (abs(distance-(rayTargets[0].global_position.distance_to(guardController.position))))
		if (currentAlertValue < maxAlertValue):
			currentAlertValue = clamp(currentAlertValue + (multValue * distanceMultiplier * multiplier * delta), 0, maxAlertValue)
			send_alert_value()
		else:
			if (researchOutcome == true):
				stop_guardCheck()
				guardAlert.start_alert(checkTarget)
			else:
				stop_guardCheck()
				guardResearch.initialize_guard_research(checkTarget)

func end_check():
	reductionOverTimeActive = false
	guardController.isChecking = false
	guardPatrol.resume_patrol()

func stop_guardCheck():
	checkActive = false
	checkWithRayCast = false
	reductionOverTimeActive = false
	guardController.isChecking = false
	preCheckActive = false

func resume_check():
	checkActive = true
	guardController.isChecking = true
	activate_reduction_over_time()

func _on_guard_damaged():
	if (guardController.isChecking == true || checkActive == true):
		stop_guardCheck()
		guardStunned.start_stun()
