class_name PlayerRoll
extends ExecuteAttack

@export var playerInputs: PlayerInputs
@export var playerHUD: PlayerHUD
@export var playerMovement: PCMovement
@export var playerMoveObjects: PlayerMoveObjects
@export var transformationChange: TransformationChange
var playerRef: PlayerCharacter

func _process(_delta):
	CheckForInput()

func ExtraReadyOperations():
	playerHUD.rollCooldown.max_value = attackCooldown
	playerHUD.rollCooldown.value = attackCooldown
	playerRef = characterRef

func CheckForInput():
	if (!attackLaunched && characterRef.playerInputs.rollInput):
		playerMoveObjects.DropMovableObject()
		if (transformationChange.isTransformed): transformationChange.transformationActivation.DeactivateTransformation()
		playerMovement.DisableMovement()
		playerInputs.SetInputsToZero()
		playerInputs.inputsLocked = true
		characterRef.invincibilityFrames = true
		start_attack()

func OnAttackEnd():
	playerMovement.EnableMovement()
	playerInputs.inputsLocked = false
	characterRef.invincibilityFrames = false

func ActiveCooldownFeedback():
	playerHUD.rollCooldown.value = attackFrame

func EndCooldownFeedback():
	playerHUD.rollCooldown.value = attackCooldown
