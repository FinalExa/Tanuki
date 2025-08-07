class_name HyottokoRange
extends Area2D

@export var hyottokoController: HyottokoController
@export var collisionShape:  CollisionShape2D
@export var baseRadius: float
@export var extendedRadius: float
var target: PlayerCharacter
var raycastActive: bool
var playerSpotStatus: int

func _ready():
	playerSpotStatus = -1
	collisionShape.shape.radius = baseRadius

func _physics_process(_delta):
	RangeRaycast()

func RangeRaycast():
	if (raycastActive && !hyottokoController.isStunned && !hyottokoController.isReachingPoint):
		var space_state = hyottokoController.get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(hyottokoController.global_position, target.global_position)
		query.exclude = [hyottokoController, hyottokoController.hyottokoAttack]
		var result = space_state.intersect_ray(query)
		if (result && result != { }):
			if (result.collider is PlayerCharacter):
				if (!CheckPlayerTransformationStatus(result.collider)):
					SetSpottingPlayer()
					return
		UnsetSpottingPlayer()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		target = body
		raycastActive = true

func _on_body_exited(body):
	if (body is PlayerCharacter):
		target = null
		raycastActive = false
		UnsetSpottingPlayer()

func SetSpottingPlayer():
	if (!hyottokoController.isSpottingPlayer):
		playerSpotStatus = 0
		hyottokoController.isSpottingPlayer = true
		collisionShape.shape.radius = extendedRadius
		hyottokoController.enemyPatrol.stop_patrol()
		if (hyottokoController.playerRef == null):
			hyottokoController.playerRef = target

func CheckPlayerTransformationStatus(playerRef: PlayerCharacter):
	var playerStatus: int = playerRef.transformationChangeRef.get_if_transformed_in_right_zone()
	if (playerSpotStatus == -1):
		playerSpotStatus = playerStatus
	if (target.velocity != Vector2.ZERO):
		playerSpotStatus = 0
		return false
	if (playerSpotStatus == 1 && playerStatus == 1):
		return true
	if (playerSpotStatus != playerStatus):
		playerSpotStatus = playerStatus
	return false

func UnsetSpottingPlayer():
	if (hyottokoController.isSpottingPlayer):
		hyottokoController.isSpottingPlayer = false
		playerSpotStatus = -1
		collisionShape.shape.radius = baseRadius
		hyottokoController.enemyPatrol.resume_patrol()
