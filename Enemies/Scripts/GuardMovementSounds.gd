class_name GuardMovementSounds
extends MovementSounds

@export var enemyController: EnemyController
@export var patrolMovementSound: AudioStreamPlayer2D
@export var alertMovementSound: AudioStreamPlayer2D
var currentMovementSound: AudioStreamPlayer2D

func _ready():
	SetPatrolSound()

func _process(_delta):
	PlayMovementSound()

func PlayMovementSound():
	if (enemyController.velocity != Vector2.ZERO):
		if (!currentMovementSound.playing):
			currentMovementSound.play()
	else:
		currentMovementSound.stop()

func SetPatrolSound():
	if (currentMovementSound != null && currentMovementSound.playing):
		currentMovementSound.stop()
	currentMovementSound = patrolMovementSound

func SetAlertSound():
	if (currentMovementSound != null && currentMovementSound.playing):
		currentMovementSound.stop()
	currentMovementSound = alertMovementSound
