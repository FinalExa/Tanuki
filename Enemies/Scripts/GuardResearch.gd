class_name GuardResearch
extends Node2D

@export var researchSpotThreshold: float
@export var researchFollowThreshold: float
@export var buildUpDuration: float
@export var onReturnToCheckAlertValue: float
@export var objectInterationDistanceThreshold: float
@export var researchEndDuration: float
@export var rayTargets: Array[Node2D]
@export var secondaryRayTargets: Array[Node2D]
@export var researchActiveText: String
@export var researchLaunchDuration: float
@export var mainAreaFeedback: Node2D
@export var secondaryAreaFeedback: Node2D
var researchLaunched: bool
var researchLaunchTimer: float
var researchEndTimer: float
var researchTarget: Node2D
var researchLastPosition: Vector2
var researchLastDirection: Vector2
@export var suspiciousItemsThresholdDistance: float
var suspiciousItemsList: Array[Node2D]
@export var stunnedGuardsThresholdDistance: float
var stunnedGuardsList: Array[GuardController]
var researchHasFoundSomething: bool
var isDoingResearchAction: bool
var isTrackingPriorityTarget: bool
@export var priorityTargetThresholdDistance: float
var mainRaycastResult: Array[Node2D]
var secondaryRaycastResult: Array[Node2D]
@export var researchEnterSound: AudioStreamPlayer2D

@export var guardController: GuardController

func _ready():
	ClearFeedbacks()

func _physics_process(_delta):
	ResearchRaycasts()

func initialize_guard_research(target: Node2D):
	stunnedGuardsList.clear()
	suspiciousItemsList.clear()
	guardController.enemyStatus.updateText(researchActiveText)
	add_feedback(mainAreaFeedback)
	add_feedback(secondaryAreaFeedback)
	reset_research_end_timer()
	if (target is PlayerCharacter):
		save_target_info(target, true)
	else: if (target is GuardController):
		save_target_info(target, false)
	guardController.isInResearch = true
	researchLaunchTimer = researchLaunchDuration
	researchLaunched = false
	researchEnterSound.play()

func ResearchRaycasts():
	if (guardController.isInResearch):
		var space_state = guardController.get_world_2d().direct_space_state
		secondaryRaycastResult = LaunchRaycast(secondaryRayTargets, space_state)
		mainRaycastResult = LaunchRaycast(rayTargets, space_state)
	
func LaunchRaycast(rayList: Array[Node2D], space_state):
	var raycastResult: Array[Node2D] = []
	raycastResult.clear()
	for i in rayList.size():
		var query = PhysicsRayQueryParameters2D.create(guardController.global_position, rayList[i].global_position)
		var result = space_state.intersect_ray(query)
		if (result && result != { }): 
			raycastResult.push_back(result.collider)
		else:
			raycastResult.push_back(null)
	return raycastResult

func save_target_info(target: Node2D, isPriotityTarget: bool):
	researchTarget = target
	researchLastPosition = researchTarget.position
	researchLastDirection = researchTarget.velocity
	isTrackingPriorityTarget = isPriotityTarget

func set_research_target(target: Vector2):
	guardController.enemyMovement.set_location_target(target)
	guardController.enemyMovement.reset_movement_speed()
	guardController.enemyRotator.setLookingAtPosition(target)

func research_to_check():
	guardController.guardCheck.currentAlertValue = onReturnToCheckAlertValue
	StopResearch()
	guardController.guardCheck.resume_check()

func StopResearch():
	ClearFeedbacks()
	guardController.isInResearch = false

func ReachedDestination():
	if (guardController.isInResearch):
		guardController.enemyRotator.setLookingAtPosition(researchLastPosition + (researchLastDirection))

func _on_guard_damaged(direction: Vector2):
	if (guardController.isInResearch):
		StopResearch()
		guardController.enemyStunned.start_stun(direction)

func OnGuardRepelled():
	if (guardController.isInResearch):
		StopResearch()

func reset_research_end_timer():
	researchEndTimer = researchEndDuration

func ClearFeedbacks():
	remove_feedback(mainAreaFeedback)
	remove_feedback(secondaryAreaFeedback)

func add_feedback(feedback: Node2D):
	feedback.show()

func remove_feedback(feedback: Node2D):
	feedback.hide()
