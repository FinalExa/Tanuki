extends Area2D

@export var guardController: GuardController
@export var enemyRotator: EnemyRotator
@export var checkValue: float
var playerIn: bool = false
var playerSave: Node2D

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerIn = true
		playerSave = body

func _on_body_exited(body):
	if (body is PlayerCharacter && playerIn):
		playerIn = false

func _process(_delta):
	PlayerTouching()

func PlayerTouching():
	if (playerIn && playerSave.transformationChangeRef.get_if_transformed_in_right_zone() != 1):
		if (guardController.isInAlert):
			guardController.guardAlert.lastTargetPosition = playerSave.global_position
			guardController.guardAlert.extraTargetLocation = playerSave.global_position
			return
		if (!guardController.isChecking && guardController.isInPatrol):
			guardController.enemyMovement.set_new_target(null)
		if (guardController.guardCheck.currentAlertValue < checkValue):
			guardController.guardCheck.currentAlertValue = checkValue
		if (!guardController.isStunned):
			enemyRotator.setLookingAtPosition(playerSave.global_position)
