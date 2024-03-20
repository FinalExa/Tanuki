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

@export var guardRotator: GuardRotator
@export var guardController: GuardController
@export var guardAlertValue: GuardAlertValue
@export var guardResearch: GuardResearch
@export var guardAlert: GuardAlert
@export var guardPatrol: GuardPatrol
@export var guardStunned: GuardStunned

func _ready():
	reset_alert_value()
	send_alert_value()
	checkActive = true

func _process(_delta):
	body_checks()

func reset_alert_value():
	currentAlertValue = 0
	controllerRef.isChecking = false

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

func activate_preCheck(target, multiplier):
	preCheckActive = true
	preCheckTimer = preCheckDuration
	detectedTarget = target
	selectedMultiplier = multiplier

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
	playerSeen = false

func activate_check(target: Node2D):
	preCheckActive = false
	guardController.isChecking = true
	guardPatrol.stop_patrol()
	checkTarget = target

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

func _on_guard_damaged(direction: Vector2):
	if (guardController.isChecking == true || checkActive == true):
		stop_guardCheck()
		guardStunned.start_stun(direction)

func send_alert_value():
	guardAlertValue.updateValue(currentAlertValue, maxAlertValue)
