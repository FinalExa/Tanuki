class_name PasswordTableInteractable
extends GenericInteractable

@export var passwordSize: int
@export var colorMarks: Array[Sprite2D]
@export var colors: Array[Color]
@export var hints: Array[PasswordHint]
@export var possibleHintPositions: Array[Node2D]
var freeHintPositions: Array[Node2D]
var usedHintPositions: Array[Node2D]
var password: Array[BrushPassive.BrushColor]
var currentProgress: int
var currentColorArray: Array[BrushPassive.BrushColor]
var done: bool

func ReadyOperations():
	RandomizePassword()
	RandomizeHints()
	ResetPassword()

func RandomizePassword():
	for i in passwordSize:
		var randInt = randi_range(0, BrushPassive.BrushColor.size() - 2)
		password.push_back(randInt)

func RandomizeHints():
	freeHintPositions.clear()
	usedHintPositions.clear()
	for i in possibleHintPositions.size():
		freeHintPositions.push_back(possibleHintPositions[i])
	for i in passwordSize:
		hints[i].ChangeColor(colors[password[i]])
		var randInt = randi_range(0, freeHintPositions.size() - 1)
		hints[i].global_position = freeHintPositions[randInt].global_position
		usedHintPositions.push_back(freeHintPositions[randInt])
		freeHintPositions.remove_at(randInt)

func ResetPassword():
	currentProgress = 0
	currentColorArray.clear()
	for i in colorMarks.size():
		colorMarks[i].modulate = colors.size() - 1

func ExecuteRefEffect(receivedRef):
	if (receivedRef is PlayerCharacter && !done):
		AnalyzeReceivedAttack(receivedRef)

func AnalyzeReceivedAttack(playerRef: PlayerCharacter):
	if (!playerRef.transformationChangeRef.isTransformed): ResetPassword()
	else:
		var brushPassive: BrushPassive = playerRef.transformationChangeRef.currentTransformationPassive
		if (brushPassive != null):
			if (brushPassive.currentColor != BrushPassive.BrushColor.NONE):
				colorMarks[currentProgress].modulate = colors[brushPassive.currentColor]
				currentColorArray.push_back(brushPassive.currentColor)
				currentProgress += 1
				brushPassive.ChangeColor(BrushPassive.BrushColor.NONE)
				CheckForCompletePassword()

func CheckForCompletePassword():
	if (currentProgress == password.size()):
		var count: int = 0
		for i in password.size():
			if (password[i] == currentColorArray[i]):
				count += 1
				continue
			break
		if (count != currentProgress):
			ResetPassword()
			return
		done = true
		ExecuteExtraEffect()
		FinalState()
