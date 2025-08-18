class_name HyottokoBossController
extends HyottokoController

var isCaptured: bool
@export var newSpeed: float
@export var armorPieces: Array[AnimatedSprite2D]

func IsRepelled(direction: Vector2):
	if (repelledSpeed > 0 && (isReachingPoint || isEntranced)):
		StartRepelled(direction)

func SetCaptured():
	if (!isCaptured):
		isCaptured = true
		InterruptAttacks()
		hyottokoReachPoint.StopReachingPoint()
		hyottokoEntranced.UnsetEntranced()
		enemyRepelled.StopRepel()
		enemyPatrol.stop_patrol()
		enemyMovement.set_new_target(null)
		velocity = Vector2.ZERO
		spriteRef.play("trapped")
		enemyStatus.updateText("")

func UnsetCaptured():
	if (isCaptured):
		isCaptured = false
		spriteRef.play("idle")
		enemyPatrol.resume_patrol()
