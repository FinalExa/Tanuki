extends Node2D

@export var playerInLabel: Label

var playerRef: PlayerCharacter

@export var cooldown: float
var timer: float
var inCooldown: bool

func _ready():
	playerInLabel.hide()

func _process(delta):
	WaitForPlayerInput()
	SubstitutionGiverCooldown(delta)

func WaitForPlayerInput():
	if (playerRef != null && !inCooldown && playerRef.playerSubstitutionAttack.currentSubstitutionStacks < playerRef.playerSubstitutionAttack.maxSubstitutionStacks):
		playerInLabel.show()
		if (playerRef.playerInputs.interactInput):
			playerRef.playerSubstitutionAttack.UpdateSubstitutionStacksValue(1)
			StartCooldown()
		return
	playerInLabel.hide()

func StartCooldown():
	timer = cooldown
	inCooldown = true

func SubstitutionGiverCooldown(delta):
	if (inCooldown):
		if (timer > 0):
			timer -= delta
			return
		inCooldown = false

func CheckIfPlayerIsIn(body):
	if (body is PlayerCharacter):
		playerRef = body

func CheckifPlayerIsOut(body):
	if (body is PlayerCharacter):
		playerRef = null
