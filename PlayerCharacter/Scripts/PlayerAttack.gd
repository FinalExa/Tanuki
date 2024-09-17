class_name PlayerAttack
extends ExecuteAttack

@export var playerHUD: PlayerHUD
@export var attackTag: String

func _process(_delta):
	check_for_attack_input()

func ExtraReadyOperations():
	SetAttackTag()

func SetAttackTag():
	for i in attackHitboxes.size():
		if (attackHitboxes[i] is PlayerAttackHitbox):
			attackHitboxes[i].attackTag = attackTag

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

func ForceStopAttack():
	ForceEndAttack()
	ForceEndCooldown()

func ForceEndCooldown():
	if (attackInCooldown):
		attackInCooldown = false
		attackFrame = 0

func ActiveCooldownFeedback():
	playerHUD.UpdateAttackCooldown(true, attackFrame, attackCooldown)

func EndCooldownFeedback():
	playerHUD.UpdateAttackCooldown(false, 0, 0)
