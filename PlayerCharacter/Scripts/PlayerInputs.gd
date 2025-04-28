class_name PlayerInputs
extends Node

var inputsForceLocked: bool
var inputsLocked: bool

var inputDirection: Vector2
var attackInput: bool
var grabInput: bool
var transformInput: bool
var obtainTransformationInput: bool
var talkInput: bool
var pauseInput: bool

func _process(_delta):
	GetInputs()

func GetInputs():
	if (!inputsForceLocked && !inputsLocked):
		GetMovementInput()
		GetAttackInput()
		GetGrabInput()
		GetTransformInput()
		GetObtainTransformationInput()
		GetTalkInput()
	GetPauseInput()

func GetMovementInput():
	inputDirection = Input.get_vector("left", "right", "up", "down")

func GetAttackInput():
	if (Input.is_action_just_pressed("attack")):
		attackInput = true
		return
	attackInput = false

func GetGrabInput():
	if (Input.is_action_just_pressed("grab")):
		grabInput = true
		return
	grabInput = false

func GetTransformInput():
	if (Input.is_action_just_pressed("transformation")):
		transformInput = true
		return
	transformInput = false

func GetObtainTransformationInput():
	if (Input.is_action_just_pressed("obtainTransformation")):
		obtainTransformationInput = true
		return
	obtainTransformationInput = false

func GetTalkInput():
	if (Input.is_action_just_pressed("talk")):
		talkInput = true
		return
	talkInput = false

func GetPauseInput():
	if (Input.is_action_just_pressed("pause")):
		pauseInput = true
		return
	pauseInput = false

func SetInputsToZero():
	inputDirection = Vector2.ZERO
	attackInput = false
	grabInput = false
	transformInput = false
	obtainTransformationInput = false
	talkInput = false
