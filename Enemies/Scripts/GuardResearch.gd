class_name GuardResearch
extends Node2D

@export var researchSpotThreshold: float
@export var researchFollowThreshold: float
@export var buildUpDuration: float
@export var onReturnToCheckAlertValue: float
@export var objectInterationDistanceThreshold: float
@export var researchEndDuration: float
@export var rayTargets: Array[Node2D]
@export var researchActiveText: String
@export var researchLaunchDuration: float
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

@export var guardController: GuardController
@export var guardAlertValue: GuardAlertValue
@export var guardAlert: GuardAlert
@export var guardPatrol: GuardPatrol
@export var guardMovement: GuardMovement
@export var guardRotator: GuardRotator
@export var guardCheck: GuardCheck
@export var guardStunned: GuardStunned

func  _physics_process(delta):
	research_active(delta)

func _process(delta):
	research_launch_timer(delta)

func initialize_guard_research(target: Node2D):
	stunnedGuardsList.clear()
	suspiciousItemsList.clear()
	guardAlertValue.updateText(researchActiveText)
	reset_research_end_timer()
	if (target is PlayerCharacter):
		researchTarget = target
		save_target_info()
	else:
		spotting_operations(target)
	guardController.isInResearch = true
	researchLaunchTimer = researchLaunchDuration
	researchLaunched = false

func save_target_info():
	researchLastPosition = researchTarget.position
	researchLastDirection = researchTarget.velocity.normalized()

func set_research_target(target: Vector2):
	guardMovement.set_location_target(target)
	guardMovement.reset_movement_speed()
	guardRotator.setLookingAtPosition(target)

func research_active(delta):
	if (guardController.isInResearch):
		research_raycasts(delta)
		priority_actions()

func research_raycasts(delta):
	if(researchLaunched):
		research_main_raycast(delta)

func research_main_raycast(delta):
	researchHasFoundSomething = false
	var space_state = guardController.get_world_2d().direct_space_state
	for i in rayTargets.size():
		var query = PhysicsRayQueryParameters2D.create(guardController.position, rayTargets[i].global_position)
		var result = space_state.intersect_ray(query)
		if (result && result != { }):
			researchHasFoundSomething = spotting_operations(result.collider)
			if (guardController.isInAlert):
				return
	if (researchHasFoundSomething == false && stunnedGuardsList.size() == 0 && suspiciousItemsList.size() == 0):
		research_end_timer(delta)
	else:
		reset_research_end_timer()

func spotting_operations(trackedObject: Node2D):
	var spotting_result: bool = false
	spotting_result = player_detection(trackedObject)
	if (spotting_result):
		stop_research()
		return spotting_result
	spotting_result = stunned_guards_detection(trackedObject)
	if (spotting_result):
		return spotting_result
	spotting_result = suspicious_objects_detection(trackedObject)
	return spotting_result

func player_detection(trackedObject: Node2D):
	if ((trackedObject is PlayerCharacter &&
	trackedObject.transformationChangeRef.isTransformed == false) ||
	trackedObject is TailFollow):
		print("found player")
		if (trackedObject is PlayerCharacter):
			guardAlert.start_alert(trackedObject)
		else:
			guardAlert.start_alert(trackedObject.playerRef)
		return true
	return false

func suspicious_objects_detection(trackedObject: Node2D):
	if (trackedObject is PlayerCharacter &&
	trackedObject.tranformationChangeRef.isTransformed == true &&
	(trackedObject.tranformationChangeRef.localAllowedItemsRef == null ||
	!trackedObject.tranformationChangeRef.localAllowedItemsRef.find(trackedObject.transformationChangeRef.currentTransformationName))):
		print("found suspicious item")
		if (!suspiciousItemsList.find(trackedObject)):
			suspiciousItemsList.push_back(trackedObject)
		return true
	return false

func stunned_guards_detection(trackedObject: Node2D):
	if (trackedObject is GuardController &&
		trackedObject.isStunned &&
		trackedObject != guardController):
			print("found stunned guard")
			if (!stunnedGuardsList.find(trackedObject)):
				stunnedGuardsList.push_back(trackedObject)
			return true
	return false

func priority_actions():
	var check: bool = false
	check = help_guards()
	if (!check):
		check = investigate_objects()
		if (check):
			return

func help_guards():
	if (stunnedGuardsList.size()>0):
		if (researchTarget != stunnedGuardsList[0]):
			researchTarget = stunnedGuardsList[0]
			set_research_target(researchTarget.global_position)
		if (guardController.global_position.distance_to(researchLastPosition) <= stunnedGuardsThresholdDistance):
			guardMovement.set_location_target(guardController.global_position)
			stunnedGuardsList[0].guardStunned.end_stun()
			stunnedGuardsList.remove_at(0)
		return true
	return false

func investigate_objects():
	if (suspiciousItemsList.size()>0):
		if (researchTarget != suspiciousItemsList[0]):
			researchTarget = suspiciousItemsList[0]
			set_research_target(researchTarget.global_position)
		if (guardController.global_position.distance_to(researchLastPosition) <= suspiciousItemsThresholdDistance):
			guardMovement.set_location_target(guardController.global_position)
			if (researchTarget is PlayerCharacter):
				var tempPlayerReference: PlayerCharacter = researchTarget
				tempPlayerReference.transformationChangeRef.deactivate_transformation()
				stop_research()
				guardAlert.start_alert(tempPlayerReference)
				suspiciousItemsList.remove_at(0)
				return true
	return false

func research_to_check():
	guardCheck.currentAlertValue = onReturnToCheckAlertValue
	stop_research()
	guardCheck.resume_check()

func stop_research():
	guardController.isInResearch = false

func _on_guard_movement_reached_destination():
	if (guardController.isInResearch == true):
		guardRotator.setLookingAtPosition(researchLastPosition + (researchLastDirection * 100))

func _on_guard_damaged():
	if (guardController.isInResearch == true):
		stop_research()
		guardStunned.start_stun()

func research_end_timer(delta):
	if (researchEndTimer>0):
		researchEndTimer-=delta
	else:
		research_to_check()

func reset_research_end_timer():
	researchEndTimer = researchEndDuration

func research_launch_timer(delta):
	if (!researchLaunched):
		if (researchLaunchTimer>0):
			researchLaunchTimer-=delta
		else:
			if (researchTarget is PlayerCharacter):
				set_research_target(researchLastPosition)
			researchLaunched = true
