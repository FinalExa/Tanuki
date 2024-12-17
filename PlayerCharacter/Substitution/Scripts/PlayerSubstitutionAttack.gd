class_name PlayerSubstitutionAttack
extends ExecuteAttack

var currentSubstitutionStacks: int = 1
@export var startingSubstitutionStacks: int
@export var maxSubstitutionStacks: int
@export var UI: PlayerHUD

func _ready():
	UpdateUI()

func _process(_delta):
	CheckForInput()

func SetStartingSubstitutionStacks():
	currentSubstitutionStacks = startingSubstitutionStacks

func CheckForInput():
	if (!attackLaunched && characterRef.playerInputs.substitutionInput && !characterRef.transformationChangeRef.isTransformed && currentSubstitutionStacks > 0):
		characterRef.playerMovement.DisableMovement()
		start_attack()
		UpdateSubstitutionStacksValue(-1)

func UpdateSubstitutionStacksValue(receivedValue: int):
	currentSubstitutionStacks = clamp (currentSubstitutionStacks + receivedValue, 0, maxSubstitutionStacks)
	UpdateUI()

func UpdateUI():
	UI.UpdateSubstitutionStacksLabel(currentSubstitutionStacks)
