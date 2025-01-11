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
var researchLaunched: bool
var researchLaunchTimer: float
var researchEndTimer: float
var researchTarget: Node2D
var researchLocation: Vector2
var researchPosition: Vector2
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

func _physics_process(_delta):
	ResearchRaycasts()

func initialize_guard_research(target: Node2D):
	stunnedGuardsList.clear()
	suspiciousItemsList.clear()
	guardController.enemyStatus.updateText(researchActiveText)
	reset_research_end_timer()
	if (target is PlayerCharacter):
		save_target_info(target, true)
	else: if (target is GuardController):
		save_target_info(target, false)
	guardController.isInResearch = true
	researchLaunchTimer = researchLaunchDuration
	researchLaunched = false
	researchEnterSound.play()

func InitializeResearchWithLocation(location: Vector2):
	stunnedGuardsList.clear()
	suspiciousItemsList.clear()
	guardController.enemyStatus.updateText(researchActiveText)
	reset_research_end_timer()
	SaveLocationInfo(location, false)
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
		query.exclude = [guardController]
		var result = space_state.intersect_ray(query)
		if (result && result != { }): 
			raycastResult.push_back(result.collider)
		else:
			raycastResult.push_back(null)
	return raycastResult

func save_target_info(target: Node2D, isPriorityTarget: bool):
	researchTarget = target
	researchLastPosition = researchTarget.position
	researchLastDirection = researchTarget.velocity
	isTrackingPriorityTarget = isPriorityTarget

func SaveLocationInfo(location: Vector2, isPriorityTarget: bool):
	researchLocation = location
	researchLastPosition = researchLocation
	researchLastDirection = Vector2.ZERO
	isTrackingPriorityTarget = isPriorityTarget

func set_research_target(target: Vector2):
	guardController.enemyMovement.set_location_target(target)
	guardController.enemyMovement.reset_movement_speed()
	guardController.enemyRotator.setLookingAtPosition(target)

func research_to_check():
	guardController.guardCheck.currentAlertValue = onReturnToCheckAlertValue
	StopResearch()
	guardController.guardCheck.resume_check()

func StopResearch():
	guardController.isInResearch = false

func ReachedDestination():
	if (guardController.isInResearch):
		guardController.enemyRotator.setLookingAtPosition(researchLastPosition + (researchLastDirection))

func _on_guard_damaged(direction: Vector2, tier: EnemyStunned.StunTier):
	if (guardController.isInResearch):
		StopResearch()
		guardController.enemyStunned.start_stun(direction, tier)

func OnGuardRepelled():
	if (guardController.isInResearch):
		StopResearch()

func reset_research_end_timer():
	researchEndTimer = researchEndDuration
