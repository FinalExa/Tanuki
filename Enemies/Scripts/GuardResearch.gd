class_name GuardResearch
extends Node2D

@export var researchSpotThreshold: float
@export var researchFollowThreshold: float
@export var buildUpDuration: float
@export var onReturnToCheckAlertValue: float
@export var objectInterationDistanceThreshold: float
@export var raycastTargets: Array[Node2D]
@export var researchActiveText: String
var buildUpTimer: float
var buildUpId: int
var buildUpActive: bool
var researchTarget: Node2D
var researchLastPosition: Vector2
var researchLastDirection: Vector2
var isTrackingAMovable: bool

@export var guardController: GuardController
@export var guardAlertValue: GuardAlertValue
@export var guardAlert: GuardAlert
@export var guardPatrol: GuardPatrol
@export var guardMovement: GuardMovement
@export var guardRotator: GuardRotator
@export var guardCheck: GuardCheck
@export var guardStunned: GuardStunned

func  _physics_process(_delta):
	research_active()

func initialize_guard_research(target: Node2D, isMovable: bool):
	researchTarget = target
	guardController.isInResearch = true
	guardAlertValue.updateText(researchActiveText)
	isTrackingAMovable = isMovable
	buildUpTimer = buildUpDuration
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

func research_active():
	if (guardController.isInResearch):
		if (isTrackingAMovable):
			follow_movable()
		else:
			follow_not_movable()

func follow_movable():
	var space_state = guardController.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(guardController.position, researchTarget.global_position)
	var result = space_state.intersect_ray(query)
	if (result && result != { }):
		spotting_operations(result.collider)

func follow_not_movable():
	if (guardController.position.distance_to(researchTarget.position) > objectInterationDistanceThreshold):
		guardMovement.set_location_target(researchTarget.position)
	else:
		if (researchTarget is PlayerCharacter):
			stop_research()
			guardAlert.start_alert(researchTarget)
		else:
			print("Removed wrong item from zone")

func spotting_operations(trackedObject: Node2D):
	if (trackedObject != researchTarget):
		set_buildup(2)
	else:
		var distance = guardController.global_position.distance_to(trackedObject.global_position)
		if (distance >= 0 && distance < researchSpotThreshold):
			set_buildup(0)
		else:
			if (distance >= researchSpotThreshold && distance < researchFollowThreshold):
				set_buildup(1)
			else:
				if (distance > researchFollowThreshold):
					set_buildup(2)

func set_buildup(id: int):
	if (buildUpActive == false || (buildUpActive == true && id != buildUpId)):
		if((buildUpActive == true && id >= buildUpId && id != 0) || buildUpActive == false):
			buildUpTimer = buildUpDuration
		buildUpId = id
		buildUpActive = true

func buildup_results():
	if (buildUpId == 2):
		research_to_check()
	else:
		if (buildUpId == 1):
			save_target_info()
			set_research_target(researchLastPosition)
		else:
			stop_research()
			guardAlert.start_alert(researchTarget)

func research_to_check():
	guardPatrol.reset_patrol()
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
