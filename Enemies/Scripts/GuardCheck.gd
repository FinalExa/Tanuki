class_name GuardCheck
extends Area2D

@export var controllerRef: GuardController
@export var maxAlertValue: float
@export var researchValueThreshold: float
@export var playerIsSeenMultiplier: float
@export var playerIsNotSeenMultiplier: float
@export var reductionOverTimeValue: float
@export var minimumIncreaseValue: float
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
var detectedTarget: Node2D
var selectedMultiplier: float
var raycastResult: Array[Node2D]

@export var guardController: GuardController

func _physics_process(delta):
	check_raycast()

func _ready():
	reset_alert_value()
	send_alert_value()
	checkActive = true

func reset_alert_value():
	currentAlertValue = 0
	controllerRef.isChecking = false

func check_raycast():
	if (checkWithRayCast):
		var space_state = get_world_2d().direct_space_state
		raycastResult.clear()
		for i in rayTargets.size():
			var query = PhysicsRayQueryParameters2D.create(guardController.global_position, rayTargets[i].global_position)
			var result = space_state.intersect_ray(query)
			if (result && result != { }): 
				raycastResult.push_back(result.collider)
			else:
				raycastResult.push_back(null)

func _on_body_entered(body):
	if (body is PlayerCharacter || body is TailFollow):
		playerInsideCheckHitbox = true
		bodySave = body

func _on_body_exited(body):
	if (body is PlayerCharacter || body is TailFollow):
		playerInsideCheckHitbox = false

func activate_reduction_over_time():
	reductionOverTimeActive = true
	playerSeen = false

func activate_check(target: Node2D):
	preCheckActive = false
	guardController.isChecking = true
	guardController.guardPatrol.stop_patrol()
	checkTarget = target

func end_check():
	reductionOverTimeActive = false
	guardController.isChecking = false
	guardController.guardPatrol.resume_patrol()

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

func _on_guard_damaged(direction: Vector2):
	if (guardController.isChecking == true || checkActive == true):
		stop_guardCheck()
		guardController.guardStunned.start_stun(direction)

func send_alert_value():
	guardController.guardAlertValue.updateValue(currentAlertValue, maxAlertValue)
