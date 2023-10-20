class_name GuardCheck
extends Area2D

@export var controllerRef: GuardController
@export var maxAlertValue: float
@export var playerOrTailIsSeenMultiplier: float
@export var playerOrTailIsNotSeenMultiplier: float
@export var distanceMultiplier: float
@export var rayTargets: Array[Node2D]
var currentAlertValue: float
var checkWithRayCast: bool

@export var guardAlertValue: GuardAlertValue

func _ready():
	reset_alert_value()
	send_alert_value()

func _physics_process(delta):
	check_for_player_with_raycast(delta)

func reset_alert_value():
	currentAlertValue = 0
	controllerRef.isChecking = false

func send_alert_value():
	guardAlertValue.updateValue(currentAlertValue, maxAlertValue)

func check_for_player_with_raycast(delta):
	if (checkWithRayCast == true):
		var space_state = get_world_2d().direct_space_state
		for i in rayTargets.size():
			var direction: Vector2 = rayTargets[i].position - controllerRef.position
			direction = direction.normalized()
			var query = PhysicsRayQueryParameters2D.create(controllerRef.position, rayTargets[i].global_position)
			var result = space_state.intersect_ray(query)
			if (result && result != { } && (result.collider == controllerRef.characterRef || result.collider == controllerRef.characterRef.tailRef)):
				determine_suspicion_type(result.collider, delta)
				break

func determine_suspicion_type(target, delta):
	if (target == controllerRef.characterRef):
		if(target.transformationChangeRef.isTransformed == false):
			print("visible player")
		else:
			print(str("player trasformed into ", target.transformationChangeRef.currentTransformationName))
			if (target.velocity != Vector2.ZERO):
				print("player transformed and moving")
			else:
				print ("player transformed and still")
				# section for the check to see if the player is trasformed inside a "wrong" zone
	else:
		if (target == controllerRef.characterRef.tailRef):
			print("visible tail")
		else:
			print("no conditions fullfilled")

func _on_body_entered(body):
	print(body.name)
	if (body == controllerRef.characterRef || body == controllerRef.characterRef.tailRef):
		checkWithRayCast = true

func _on_body_exited(body):
	if (body == controllerRef.characterRef || body == controllerRef.characterRef.tailRef):
		checkWithRayCast = false
