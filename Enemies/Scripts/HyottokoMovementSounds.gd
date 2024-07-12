extends MovementSounds

@export var hyottokoController: HyottokoController
@export var normalMovementSounds: Array[AudioStreamPlayer2D]
@export var rageMovementSounds: Array[AudioStreamPlayer2D]

var lastState: bool

func _ready():
	SwitchLastState(false, normalMovementSounds)

func _process(_delta):
	PlayMovementSounds()

func PlayMovementSounds():
	if (lastState != hyottokoController.isInRage):
		if (hyottokoController.isInRage):
			SwitchLastState(hyottokoController.isInRage, rageMovementSounds)
		else:
			SwitchLastState(hyottokoController.isInRage, normalMovementSounds)
		return
	if (hyottokoController.velocity != Vector2.ZERO):
		if (!currentMovementSound.playing):
			SelectNextStep()
	else:
		currentMovementSound.stop()

func SwitchLastState(newState: bool, newArray: Array[AudioStreamPlayer2D]):
	lastState = newState
	ResetFirstStep()
	SetSoundsArray(newArray)
