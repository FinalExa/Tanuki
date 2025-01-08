class_name PlayerSubstitutionAttack
extends ExecuteAttack

var currentSubstitutionStacks: int
@export var startingSubstitutionStacks: int
@export var maxSubstitutionStacks: int
@export var playerAttack: PlayerAttack
@export var UI: PlayerHUD

func ExtraReadyOperations():
	UpdateUI()

func _process(_delta):
	CheckForInput()

func SetStartingSubstitutionStacks():
	currentSubstitutionStacks = startingSubstitutionStacks

func CheckForInput():
	if (!attackLaunched && !playerAttack.attackLaunched && characterRef.playerInputs.substitutionInput && !characterRef.transformationChangeRef.isTransformed && currentSubstitutionStacks > 0):
		characterRef.playerMovement.DisableMovement()
		characterRef.transformationInvincibility = true
		start_attack()
		UpdateSubstitutionStacksValue(-1)

func OnAttackEnd():
	characterRef.playerMovement.EnableMovement()
	characterRef.transformationInvincibility = false

func UpdateSubstitutionStacksValue(receivedValue: int):
	currentSubstitutionStacks = clamp(currentSubstitutionStacks + receivedValue, 0, maxSubstitutionStacks)
	UpdateUI()

func ForceStopAttack():
	ForceEndAttack()
	ForceEndCooldown()
	attackLaunched = false
	characterRef.transformationInvincibility = false

func ForceEndCooldown():
	if (attackInCooldown):
		attackInCooldown = false
		attackFrame = 0

func UpdateUI():
	UI.UpdateSubstitutionStacksLabel(currentSubstitutionStacks)
