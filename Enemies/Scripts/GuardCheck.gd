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
			if (target.velocity != Vector2.ZERO):
				print("player transformed and moving")
			else:
				var localAllowRef: LocalAllowedItems = target.transformationChangeRef.localAllowedItemsRef
				if (localAllowRef == null || (localAllowRef != null && !localAllowRef.allowedObjects.has(target.transformationChangeRef.currentTransformationName))):
					print("transformed in the wrong zone")
				else:
					print ("transformed in the right zone")
	else:
		if (target == controllerRef.characterRef.tailRef):
			print("visible tail")

func _on_body_entered(body):
	if (body == controllerRef.characterRef || body == controllerRef.characterRef.tailRef):
		checkWithRayCast = true

func _on_body_exited(body):
	if (body == controllerRef.characterRef || body == controllerRef.characterRef.tailRef):
		checkWithRayCast = false
