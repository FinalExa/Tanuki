class_name GuardMovementSounds
extends MovementSounds

@export var guardController: GuardController
@export var patrolMovementSounds: Array[AudioStreamPlayer2D]
@export var alertMovementSounds: Array[AudioStreamPlayer2D]

var lastState: bool

func _ready():
	SwitchLastState(false, patrolMovementSounds)

func _process(_delta):
	PlayMovementSounds()

func PlayMovementSounds():
	if (lastState != guardController.isInAlert):
		if (guardController.isInAlert):
			SwitchLastState(guardController.isInAlert, alertMovementSounds)
		else:
			SwitchLastState(guardController.isInAlert, patrolMovementSounds)
		return
	if (guardController.velocity != Vector2.ZERO):
		if (!currentMovementSound.playing):
			SelectNextStep()
	else:
		currentMovementSound.stop()

func SwitchLastState(newState: bool, newArray: Array[AudioStreamPlayer2D]):
	lastState = newState
	ResetFirstStep()
	SetSoundsArray(newArray)
