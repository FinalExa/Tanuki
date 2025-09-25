class_name HyottokoRange
extends Area2D

@export var hyottokoController: HyottokoController
@export var collisionShape: CollisionShape2D
@export var baseRadius: float
@export var extendedRadius: float
@export var timeBeforeUnset: float
@export var rayPoints: Array[Node2D]
var unsetTimer: float
var unsetTimerActive: bool
var target: PlayerCharacter
var playerSpotStatus: int

func _ready():
	playerSpotStatus = -1
	unsetTimer = 0
	collisionShape.shape.radius = baseRadius

func _process(delta):
	UnsetTimer(delta)

func _physics_process(_delta):
	RangeRaycast()

func RangeRaycast():
	if (target != null && !hyottokoController.isEntranced && !hyottokoController.isStunned && !hyottokoController.isReachingPoint):
		var space_state = hyottokoController.get_world_2d().direct_space_state
		for i in rayPoints.size():
			var query = PhysicsRayQueryParameters2D.create(hyottokoController.global_position, rayPoints[i].global_position)
			query.exclude = [hyottokoController, collisionShape, hyottokoController.hyottokoAttack]
			var result = space_state.intersect_ray(query)
			if (result && result != { }):
				if (result.collider is PlayerCharacter):
					if (!CheckPlayerTransformationStatus(result.collider)):
						SetSpottingPlayer()
						return
		if (!unsetTimerActive):
			unsetTimerActive = true

func _on_body_entered(body):
	if (body is PlayerCharacter):
		target = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		target = null
		unsetTimerActive = true

func SetSpottingPlayer():
	if (!hyottokoController.isSpottingPlayer):
		playerSpotStatus = 0
		hyottokoController.isSpottingPlayer = true
		collisionShape.shape.radius = extendedRadius
		unsetTimer = timeBeforeUnset
		unsetTimerActive = false
		if (hyottokoController.playerRef == null):
			hyottokoController.playerRef = target

func UnsetTimer(delta):
	if (unsetTimerActive):
		if (unsetTimer > 0):
			unsetTimer -= delta
			return
		UnsetSpottingPlayer()

func CheckPlayerTransformationStatus(playerRef: PlayerCharacter):
	var playerStatus: int = playerRef.transformationChangeRef.get_if_transformed_in_right_zone()
	if (playerSpotStatus == -1):
		playerSpotStatus = playerStatus
	if (playerSpotStatus == 1 && playerStatus == 1):
		return true
	if (playerSpotStatus != playerStatus):
		playerSpotStatus = playerStatus
	return false

func UnsetSpottingPlayer():
	if (hyottokoController.isSpottingPlayer):
		hyottokoController.isSpottingPlayer = false
		unsetTimerActive = false
		playerSpotStatus = -1
		collisionShape.shape.radius = baseRadius
		unsetTimer = 0
