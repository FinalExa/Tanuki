class_name GuardCheck
extends Area2D

@export var controllerRef: GuardController
@export var maxAlertValue: float
@export var playerOrTailIsSeenMultiplier: float
@export var playerOrTailIsNotSeenMultiplier: float
@export var distanceMultiplier: float
@export var rayLength: float
@export var rayTargets: Array[Node2D]
var currentAlertValue: float
var checkWithRayCast: bool

@export var guardAlertValue: GuardAlertValue

func _ready():
	reset_alert_value()
	send_alert_value()

func _physics_process(delta):
	check_for_player_with_raycast()

func reset_alert_value():
	currentAlertValue = 0
	controllerRef.isChecking = false

func send_alert_value():
	guardAlertValue.updateValue(currentAlertValue, maxAlertValue)

func _on_body_entered(body):
	if (body == controllerRef.characterRef):
		checkWithRayCast = true

func _on_body_exited(body):
	if (body == controllerRef.characterRef):
		checkWithRayCast = false

func check_for_player_with_raycast():
	if (checkWithRayCast == true):
		var space_state = get_world_2d().direct_space_state
		for i in rayTargets.size():
			var direction: Vector2 = rayTargets[i].position - controllerRef.position
			direction = direction.normalized()
			var query = PhysicsRayQueryParameters2D.create(controllerRef.position, rayTargets[i].global_position)
			var result = space_state.intersect_ray(query)
			if (result && result != { } && result.collider == controllerRef.characterRef):
				print("Ciao!")
				checkWithRayCast = false
				break
