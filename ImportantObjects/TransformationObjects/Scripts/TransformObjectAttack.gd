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
	characterRef.velocity = Vector2.ZERO
	ExecuteAttackPhase()

func FinalizeAttack():
	characterRef.playerMovement.EnableMovement()
	attackLaunched = false

func StartCooldown():
	attackInCooldown = true
	attackFrame = 0
	characterRef.playerMovement.EnableMovement()

func ActiveCooldownFeedback():
	if (characterRef is PlayerCharacter):
		var playerRef: PlayerCharacter = characterRef
		if (playerRef.transformationChangeRef.isTransformed):
			playerRef.playerHUD.UpdateAttackCooldown(true, attackFrame, attackCooldown)

func EndCooldownFeedback():
	if (characterRef is PlayerCharacter):
		var playerRef: PlayerCharacter = characterRef
		if (playerRef.transformationChangeRef.isTransformed):
			playerRef.playerHUD.UpdateAttackCooldown(false, 0, 0)
