class_name HyottokoRange
extends Area2D

@export var hyottokoController: HyottokoController
var target: PlayerCharacter
var raycastActive: bool

func _physics_process(_delta):
	RangeRaycast()

func RangeRaycast():
	if (raycastActive):
		var space_state = hyottokoController.get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(hyottokoController.global_position, target.global_position)
		var result = space_state.intersect_ray(query)
		if (result && result != { } && result.collider is PlayerCharacter): 
			if (!hyottokoController.isSpottingPlayer):
				SetSpottingPlayer()
		else:
			if (hyottokoController.isSpottingPlayer):
				UnsetSpottingPlayer()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		target = body
		raycastActive = true

func _on_body_exited(body):
	if (body is PlayerCharacter):
		target = null
		raycastActive = false
		if (hyottokoController.isSpottingPlayer):
			UnsetSpottingPlayer()

func SetSpottingPlayer():
	hyottokoController.isSpottingPlayer = true
	hyottokoController.enemyPatrol.stop_patrol()
	if (hyottokoController.playerRef == null):
		hyottokoController.playerRef = target

func UnsetSpottingPlayer():
	hyottokoController.isSpottingPlayer = false
	hyottokoController.enemyPatrol.resume_patrol()
