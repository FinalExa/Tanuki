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
var researchEndTimer: float
var researchTarget: Node2D
var researchLastPosition: Vector2
var researchLastDirection: Vector2
var suspiciousItemsList: Array[Node2D]
var stunnedGuardsList: Array[GuardController]
var researchHasFoundSomething: bool

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

func initialize_guard_research(target: Node2D):
	researchTarget = target
	guardController.isInResearch = true
	guardAlertValue.updateText(researchActiveText)
	research_setup()

func research_setup():
	save_target_info()
	set_research_target(researchLastPosition)

func save_target_info():
	researchLastPosition = researchTarget.position
	researchLastDirection = researchTarget.velocity.normalized()

func set_research_target(target: Vector2):
	guardMovement.set_location_target(target)
	guardMovement.reset_movement_speed()
	guardRotator.setLookingAtPosition(target)

func research_active(delta):
	if (guardController.isInResearch):
		researchHasFoundSomething = false
		var space_state = guardController.get_world_2d().direct_space_state
		for i in rayTargets.size():
			var query = PhysicsRayQueryParameters2D.create(guardController.position, rayTargets[i].global_position)
			var result = space_state.intersect_ray(query)
			if (result && result != { }):
				researchHasFoundSomething = spotting_operations(result.collider)
				if (guardController.isInAlert):
					return
		if (researchHasFoundSomething == false):
			research_end_timer(delta)
		else:
			reset_research_end_timer()

func spotting_operations(trackedObject: Node2D):
	if ((trackedObject is PlayerCharacter &&
	trackedObject.transformationChangeRef.isTransformed == false) ||
	trackedObject is TailFollow):
		stop_research()
		if (trackedObject is PlayerAttack):
			guardAlert.start_alert(trackedObject)
		else:
			guardAlert.start_alert(trackedObject.playerRef)
		return true
	if (!suspiciousItemsList.find(trackedObject) &&
	(trackedObject is PlayerCharacter &&
	trackedObject.tranformationChangeRef.isTransformed == true &&
	(trackedObject.tranformationChangeRef.localAllowedItemsRef == null ||
	!trackedObject.tranformationChangeRef.localAllowedItemsRef.find(trackedObject.transformationChangeRef.currentTransformationName)))):
		suspiciousItemsList.push_back(trackedObject)
		return true
	if (!stunnedGuardsList.find(trackedObject) &&
		(trackedObject is GuardController &&
		trackedObject.isStunned &&
		trackedObject != guardController)):
			stunnedGuardsList.push_back(trackedObject)
			return true

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
