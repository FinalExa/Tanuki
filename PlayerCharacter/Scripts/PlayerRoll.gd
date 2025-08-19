class_name PlayerRoll
extends ExecuteAttack

@export var playerInputs: PlayerInputs
@export var playerHUD: PlayerHUD
@export var playerMovement: PCMovement
@export var playerMoveObjects: PlayerMoveObjects
@export var transformationChange: TransformationChange

func _process(_delta):
	CheckForInput()

func CheckForInput():
	if (!attackLaunched && characterRef.playerInputs.rollInput):
		playerMoveObjects.DropMovableObject()
		if (transformationChange.currentTransformationObject != null): transformationChange.transformationActivation.DeactivateTransformation()
		playerMovement.DisableMovement()
		playerInputs.SetInputsToZero()
		playerInputs.inputsLocked = true
		characterRef.invincibilityFrames = true
		start_attack()

func OnAttackEnd():
	playerMovement.EnableMovement()
	playerInputs.inputsLocked = false
	characterRef.invincibilityFrames = false
