class_name PlayerAttack
extends ExecuteAttack

@export var playerHUD: PlayerHUD

func _process(_delta):
	check_for_attack_input()

func check_for_attack_input():
	if (!attackLaunched && characterRef.playerInputs.attackInput && !characterRef.transformationChangeRef.isTransformed):
		characterRef.playerMovement.DisableMovement()
		start_attack()

func FinalizeAttack():
	characterRef.playerMovement.EnableMovement()
	attackLaunched = false

func StartCooldown():
	attackInCooldown = true
	attackFrame = 0
	characterRef.playerMovement.EnableMovement()

func ActiveCooldownFeedback():
	playerHUD.UpdateAttackCooldown(true, attackFrame, attackCooldown)

func EndCooldownFeedback():
	playerHUD.UpdateAttackCooldown(false, 0, 0)
