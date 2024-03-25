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
var mainAreaFeedbackInstance: Node2D
var secondaryAreaFeedbackInstance: Node2D
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

@export var guardController: GuardController

func _ready():
	startup_feedbacks()

func _physics_process(_delta):
	research_raycasts()

func initialize_guard_research(target: Node2D):
	stunnedGuardsList.clear()
	suspiciousItemsList.clear()
	guardController.guardAlertValue.updateText(researchActiveText)
	mainAreaFeedbackInstance = add_feedback(mainAreaFeedback)
	secondaryAreaFeedbackInstance = add_feedback(secondaryAreaFeedback)
	reset_research_end_timer()
	if (target is PlayerCharacter || target is GuardController):
		save_target_info(target)
	guardController.isInResearch = true
	researchLaunchTimer = researchLaunchDuration
	researchLaunched = false

func research_raycasts():
	if (guardController.isInResearch):
		secondaryRaycastResult = launch_raycast(secondaryRayTargets)
		mainRaycastResult = launch_raycast(rayTargets)
	
func launch_raycast(rayList: Array[Node2D]):
	var raycastResult: Array[Node2D] = []
	raycastResult.clear()
	var space_state = get_world_2d().direct_space_state
	for i in rayList.size():
		var query = PhysicsRayQueryParameters2D.create(guardController.global_position, rayList[i].global_position)
		var result = space_state.intersect_ray(query)
		if (result && result != { }): 
			raycastResult.push_back(result.collider)
		else:
			raycastResult.push_back(null)
	return raycastResult

func save_target_info(target):
	researchTarget = target
	researchLastPosition = researchTarget.position
	researchLastDirection = researchTarget.velocity
	isTrackingPriorityTarget = true

func set_research_target(target: Vector2):
	guardController.guardMovement.set_location_target(target)
	guardController.guardMovement.reset_movement_speed()
	guardController.guardRotator.setLookingAtPosition(target)

func research_to_check():
	guardController.guardCheck.currentAlertValue = onReturnToCheckAlertValue
	stop_research()
	guardController.guardCheck.resume_check()

func stop_research():
	remove_feedback(mainAreaFeedbackInstance)
	remove_feedback(secondaryAreaFeedbackInstance)
	guardController.isInResearch = false

func _on_guard_movement_reached_destination():
	if (guardController.isInResearch == true):
		guardController.guardRotator.setLookingAtPosition(researchLastPosition + (researchLastDirection * 100))

func _on_guard_damaged(direction: Vector2):
	if (guardController.isInResearch == true):
		stop_research()
		guardController.guardStunned.start_stun(direction)

func reset_research_end_timer():
	researchEndTimer = researchEndDuration

func startup_feedbacks():
	mainAreaFeedbackInstance = mainAreaFeedback
	remove_feedback(mainAreaFeedbackInstance)
	secondaryAreaFeedbackInstance = secondaryAreaFeedback
	remove_feedback(secondaryAreaFeedbackInstance)

func add_feedback(feedbackToAdd):
	add_child(feedbackToAdd)
	for i in get_child_count():
		if (get_child(i) == feedbackToAdd):
			return get_child(i)

func remove_feedback(feedbackToRemove: Node2D):
	if(feedbackToRemove != null):
		remove_child(feedbackToRemove)
		feedbackToRemove = null
