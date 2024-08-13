class_name EnemyStunned
extends Node

signal end_stun_signal

@export var stunDuration: float
@export var stunEndAlertValue: float
@export var stunnedText: String
@export var stunnedSound: AudioStreamPlayer2D
var stunTimer: float
var stunnedFromAlert: bool = false

@export var enemyController: EnemyController

var lookDirectionAfterStun: Vector2

func start_stun(direction: Vector2):
	ExecuteStunStartup(direction)

func ExecuteStunStartup(direction: Vector2):
	stunTimer = stunDuration
	lookDirectionAfterStun = direction
	enemyController.enemyMovement.set_new_target(null)
	enemyController.enemyStatus.updateText(stunnedText)
	enemyController.isStunned = true
	if (!stunnedSound.playing): stunnedSound.play()
	if (stunnedFromAlert):
		enemyController.enemyPatrol.select_new_patrol_indicator()
		stunnedFromAlert = false

func end_stun():
	ExecuteStunEnd()

func ExecuteStunEnd():
	clear_guards_looking_for_me()
	enemyController.enemyRotator.setLookingAtPosition((lookDirectionAfterStun * 10) + enemyController.global_position)
	enemyController.isStunned = false
	enemyController.enemyPatrol.resume_patrol()
	enemyController.enemyStatus.updateText("")
	if (stunnedSound.playing): stunnedSound.stop()
	emit_signal("end_stun_signal")

func clear_guards_looking_for_me():
	for i in enemyController.guardsLookingForMe.size():
		for y in enemyController.guardsLookingForMe[i].stunnedGuardsList.size():
			if (enemyController.guardsLookingForMe[i].stunnedGuardsList[y] == enemyController):
				enemyController.guardsLookingForMe[i].stunnedGuardsList.remove_at(y)
				break
	enemyController.guardsLookingForMe.clear()
