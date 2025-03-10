class_name GuardCheck
extends Area2D

@export var guardController: GuardController
@export var maxAlertValue: float
@export var researchValueThreshold: float
@export var playerIsSeenMultiplier: float
@export var playerIsNotSeenMultiplier: float
@export var designatedTarget: Node2D
@export var designatedTargetDistanceOverflow: float
@export var reductionOverTimeValue: float
@export var minimumIncreaseValue: float
@export var distanceMultiplier: float
@export var rayTargetsContainer: Node2D
@export var preCheckDuration: float
@export var checkingSound: AudioStreamPlayer2D
var rayTargets: Array[Node2D]
var checkActive: bool
var checkWithRayCast: bool
var preCheckActive: bool
var reductionOverTimeActive: bool
var playerInsideCheckHitbox: bool
var playerSeen: bool
var checkTarget: Node2D
var currentAlertValue: float
var preCheckTimer: float
var researchOutcome: bool
var bodySave: Node2D
var detectedTarget: Node2D
var selectedMultiplier: float
var raycastResult: Array[Node2D]
var designatedTargetDistance: float

func _physics_process(_delta):
	check_raycast()

func _ready():
	GetRayTargets()
	reset_alert_value()
	send_alert_value()
	CalculateDistanceToSelectedPoint()
	checkActive = true

func CalculateDistanceToSelectedPoint():
	designatedTargetDistance = guardController.global_position.distance_to(designatedTarget.global_position) + designatedTargetDistanceOverflow

func GetRayTargets():
	rayTargets.clear()
	for i in rayTargetsContainer.get_child_count():
		rayTargets.push_back(rayTargetsContainer.get_child(i))

func reset_alert_value():
	currentAlertValue = 0
	guardController.isChecking = false

func check_raycast():
	if (checkWithRayCast):
		var space_state = guardController.get_world_2d().direct_space_state
		raycastResult.clear()
		for i in rayTargets.size():
			var query = PhysicsRayQueryParameters2D.create(guardController.global_position, rayTargets[i].global_position)
			query.exclude = [guardController]
			var result = space_state.intersect_ray(query)
			if (result && result != { }):
				raycastResult.push_back(result.collider)
			else:
				raycastResult.push_back(null)

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerInsideCheckHitbox = true
		bodySave = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerInsideCheckHitbox = false

func ActivateReduction():
	reductionOverTimeActive = true
	playerSeen = false

func StartCheck(target: Node2D):
	preCheckActive = false
	guardController.isChecking = true
	checkingSound.play()
	guardController.enemyPatrol.stop_patrol()
	checkTarget = target

func ForceActivateCheck():
	preCheckActive = false
	guardController.isChecking = true
	checkingSound.play()

func EndCheck():
	reductionOverTimeActive = false
	guardController.isChecking = false
	guardController.enemyPatrol.resume_patrol()

func StopCheck():
	checkActive = false
	checkWithRayCast = false
	reductionOverTimeActive = false
	guardController.isChecking = false
	preCheckActive = false

func resume_check():
	checkActive = true
	guardController.isChecking = true
	ActivateReduction()

func _on_guard_damaged(direction: Vector2, tier: EnemyStunned.StunTier):
	if (guardController.isChecking || checkActive):
		StopCheck()
		guardController.enemyStunned.start_stun(direction, tier)

func OnGuardRepelled():
	if (guardController.isChecking || checkActive):
		StopCheck()

func send_alert_value():
	guardController.enemyStatus.updateValue(currentAlertValue, maxAlertValue)
