class_name GuardResearch
extends Node

@export var researchSpotThreshold: float
@export var researchFollowThreshold: float
@export var buildUpDuration: float
@export var onReturnToCheckAlertValue: float
@export var objectInterationDistanceThreshold: float
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
@export var guardPatrol: GuardPatrol
@export var guardMovement: GuardMovement
@export var guardRotator: GuardRotator
@export var guardCheck: GuardCheck

func  _physics_process(delta):
	research_active(delta)
	pass

func initialize_guard_research(target: Node2D, isMovable: bool):
	researchTarget = target
	guardController.isInResearch = true
	guardAlertValue.updateText(researchActiveText)
	isTrackingAMovable = isMovable
	research_setup()

func research_setup():
	save_target_info()
	set_research_target(researchLastPosition)

func save_target_info():
	researchLastPosition = researchTarget.position
	researchLastDirection = researchTarget.velocity.normalized()

func set_research_target(researchTarget: Vector2):
	guardMovement.set_location_target(researchTarget)
	guardMovement.reset_movement_speed()
	guardRotator.setLookingAtPosition(researchTarget)

func research_active(delta):
	if (guardController.isInResearch):
		if (isTrackingAMovable):
			follow_movable(delta)
		else:
			follow_not_movable(delta)

func follow_movable(delta):
	var space_state = guardController.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(guardController.position, researchTarget.global_position)
	var result = space_state.intersect_ray(query)
	if (result && result != { }):
		spotting_operations(result.collider, delta)

func follow_not_movable(delta):
	if (guardController.position.distance_to(researchTarget.position) > objectInterationDistanceThreshold):
		guardMovement.set_location_target(researchTarget.position)
	else:
		if (researchTarget is PlayerCharacter):
			print("Touched Player -> Alert!")
		else:
			print("Removed wrong item from zone")

func spotting_operations(trackedObject: Node2D, delta):
	if (trackedObject != researchTarget):
		buildup(2, delta)
	else:
		var distance = guardController.position.distance_to(trackedObject.position)
		if (distance >= 0 && distance < researchSpotThreshold):
			buildup(0, delta)
		else:
			if (distance >= researchSpotThreshold && distance < researchFollowThreshold):
				buildup(1, delta)
			else:
				buildup(2, delta)

func buildup(id: int, delta):
	if (buildUpActive == false || (buildUpActive == true && id != buildUpId)):
		set_buildup(id)
	if (buildUpActive == true):
		buildup_timer(delta)

func set_buildup(id: int):
	if(buildUpActive == true && id >= buildUpId && id != 0):
		buildUpTimer = buildUpDuration
	buildUpId = id
	buildUpActive = true

func buildup_timer(delta):
	if (buildUpTimer > 0):
		buildUpTimer-=delta
	else:
		buildUpActive = false
		buildup_results()

func buildup_results():
	if (buildUpId == 2):
		research_to_check()
	else:
		if (buildUpId == 1):
			save_target_info()
			set_research_target(researchLastPosition)
		else:
			print("ALERT")

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
