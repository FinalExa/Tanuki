class_name PlayerInputs
extends Node

var inputsForceLocked: bool
var inputsLocked: bool

var inputDirection: Vector2
var attackInput: bool
var transformInput: bool
var interactInput: bool
var substitutionInput: bool
var pauseInput: bool

func _process(_delta):
	GetInputs()

func GetInputs():
	if (!inputsForceLocked && !inputsLocked):
		GetMovementInput()
		GetAttackInput()
		GetTransformInput()
		GetInteractInput()
		GetSubstitutionInput()
	GetPauseInput()

func GetMovementInput():
	inputDirection = Input.get_vector("left", "right", "up", "down")

func GetAttackInput():
	if (Input.is_action_just_pressed("attack")):
		attackInput = true
		return
	attackInput = false

func GetTransformInput():
	if (Input.is_action_just_pressed("transformation")):
		transformInput = true
		return
	transformInput = false

func GetInteractInput():
	if (Input.is_action_just_pressed("interact")):
		interactInput = true
		return
	interactInput = false

func GetSubstitutionInput():
	if (Input.is_action_just_pressed("substitution")):
		substitutionInput = true
		return
	substitutionInput = false

func GetPauseInput():
	if (Input.is_action_just_pressed("pause")):
		pauseInput = true
		return
	pauseInput = false

func SetInputsToZero():
	inputDirection = Vector2.ZERO
	attackInput = false
	transformInput = false
	interactInput = false
