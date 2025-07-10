class_name EnemyStunned
extends Node

signal start_stun_signal
signal end_stun_signal

@export var stunDuration: float
@export var stunEndAlertValue: float
@export var stunnedText: String
@export var stunnedSound: AudioStreamPlayer2D
var stunTimer: float
var stunnedFromAlert: bool = false

@export var enemyController: EnemyController

enum StunTier {
	LOW,
	MEDIUM,
	HIGH
}

var stunTierValues: Array[float] = [3.0, 5.0, 10.0]

var lookDirectionAfterStun: Vector2

func start_stun(direction: Vector2, tier: StunTier):
	ExecuteStunStartup(direction, tier)

func ExecuteStunStartup(direction: Vector2, tier: StunTier):
	stunTimer = stunTierValues[tier]
	lookDirectionAfterStun = direction
	enemyController.enemyMovement.set_new_target(null)
	enemyController.enemyStatus.updateText(stunnedText)
	enemyController.isStunned = true
	if (!stunnedSound.playing): stunnedSound.play()
	if (stunnedFromAlert):
		enemyController.enemyPatrol.select_new_patrol_indicator()
		stunnedFromAlert = false
	emit_signal("start_stun_signal")

func end_stun():
	ExecuteStunEnd()

func ExecuteStunEnd():
	enemyController.enemyRotator.setLookingAtPosition((lookDirectionAfterStun * 10) + enemyController.global_position)
	enemyController.isStunned = false
	enemyController.enemyPatrol.resume_patrol()
	enemyController.enemyStatus.updateText("")
	if (stunnedSound.playing): stunnedSound.stop()
	emit_signal("end_stun_signal")
