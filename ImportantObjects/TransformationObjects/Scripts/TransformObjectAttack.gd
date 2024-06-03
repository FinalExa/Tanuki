class_name TransformObjectAttack
extends ExecuteAttack

@export var attackTag: String

func ExtraReadyOperations():
	SetAttackTag()

func SetAttackTag():
	for i in attackHitboxes.size():
		if (attackHitboxes[i] is ObjectAttackHitbox):
			attackHitboxes[i].attackTag = attackTag

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
