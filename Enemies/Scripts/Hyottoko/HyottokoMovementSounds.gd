extends MovementSounds

@export var hyottokoController: HyottokoController
@export var movementSounds: Array[AudioStreamPlayer2D]

var lastState: bool

func _ready():
	ResetFirstStep()
	SetSoundsArray(movementSounds)

func _process(_delta):
	PlayMovementSounds()

func PlayMovementSounds():
	if (hyottokoController.velocity != Vector2.ZERO):
		if (!currentMovementSound.playing):
			SelectNextStep()
	else:
		currentMovementSound.stop()
