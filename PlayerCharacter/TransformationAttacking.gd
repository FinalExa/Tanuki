class_name TransformationAttacking
extends Node

@export var transformationChange: TransformationChange

func CheckForAttackInput():
	if (transformationChange.isTransformed && transformationChange.currentAttack != null && !transformationChange.currentAttack.attackLaunched && !transformationChange.currentAttack.attackInCooldown && transformationChange.playerRef.playerInputs.attackInput):
		transformationChange.currentAttack.start_attack()

func AttackDetractTimer():
	if (transformationChange.isTransformed):
		transformationChange.transformationTimer = clamp(transformationChange.transformationTimer + transformationChange.transformationAttackTimerCost, 0, transformationChange.transformationDuration)
