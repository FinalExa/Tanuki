class_name PlayerRoll
extends ExecuteAttack

@export var playerInputs: PlayerInputs
@export var playerHUD: PlayerHUD
@export var playerMovement: PCMovement
@export var playerMoveObjects: PlayerMoveObjects
@export var transformationChange: TransformationChange
var playerRef: PlayerCharacter
var transformationUpgrade: bool
var movableUpgrade: bool

func _process(_delta):
	CheckForInput()
	CheckForTransformationInputWithUpgrade()

func ResetUpgrades():
	transformationUpgrade = false
	movableUpgrade = false

func EnableTransformationUpgrade():
	transformationUpgrade = true

func EnableMovableUpgrade():
	movableUpgrade = true

func ExtraReadyOperations():
	playerHUD.rollCooldown.max_value = attackCooldown
	playerHUD.rollCooldown.value = attackCooldown
	playerRef = characterRef

func CheckForInput():
	if (!attackLaunched && playerRef.playerHealth.invincibilityTimer <= 0 && characterRef.playerInputs.rollInput):
		if (!movableUpgrade): playerMoveObjects.DropMovableObject()
		if (transformationChange.isTransformed): transformationChange.transformationActivation.DeactivateTransformation()
		playerMovement.DisableMovement()
		playerInputs.SetInputsToZero()
		playerInputs.inputsLocked = true
		characterRef.invincibilityFrames = true
		start_attack()

func CheckForTransformationInputWithUpgrade():
	if (transformationUpgrade && attackLaunched && Input.is_action_just_pressed("transformation") && !playerRef.transformationChangeRef.superUndetectable && playerRef.transformationChangeRef.currentTransformationObject != null):
		playerRef.transformationChangeRef.superUndetectable = true

func OnAttackEnd():
	playerMovement.EnableMovement()
	if (playerRef.transformationChangeRef.superUndetectable):
		transformationChange.superUndetectable = false
		playerRef.playerInputs.transformInput = true
		transformationChange.transformationActivation.ActivateTransformation()
	playerInputs.inputsLocked = false
	characterRef.invincibilityFrames = false

func ActiveCooldownFeedback():
	playerHUD.rollCooldown.value = attackFrame

func EndCooldownFeedback():
	playerHUD.rollCooldown.value = attackCooldown
