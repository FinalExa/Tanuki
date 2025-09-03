class_name HyottokoBossController
extends HyottokoController

var isCaptured: bool
@export var newSpeed: float
@export var armorPieces: Array[AnimatedSprite2D]

func IsRepelled(direction: Vector2):
	if (enemyRepelled.repelledSpeed > 0 && (isReachingPoint || isEntranced)):
		enemyRepelled.StartRepelled(direction)

func UpdateSpeed():
	enemyMovement.set_movement_speed(newSpeed)
	enemyMovement.defaultMovementSpeed = newSpeed

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
