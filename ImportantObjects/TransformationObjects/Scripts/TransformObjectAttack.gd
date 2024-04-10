class_name TransformObjectAttack
extends ExecuteAttack

func start_attack():
	attackLaunched = true
	attackFrame = 0
	characterRef.playerMovement.DisableMovement()
	ExecuteAttackPhase()

func FinalizeAttack():
	characterRef.playerMovement.EnableMovement()
	attackLaunched = false

func StartCooldown():
	attackInCooldown = true
	attackFrame = 0
	characterRef.playerMovement.EnableMovement()
