extends MovementSounds

@export var enemyController: EnemyController
@export var cleanerMovementSounds: Array[AudioStreamPlayer2D]

func _ready():
	SetSoundsArray(cleanerMovementSounds)

func _process(delta):
	CheckForMovement()

func CheckForMovement():
	if (enemyController.velocity != Vector2.ZERO):
		if (!currentMovementSound.playing):
			SelectNextStep()
	else:
		ResetFirstStep()
