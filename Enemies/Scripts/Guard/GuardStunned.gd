class_name GuardStunned
extends EnemyStunned

func end_stun():
	enemyController.enemyRotator.setLookingAtPosition((lookDirectionAfterStun * 10) + enemyController.global_position)
	enemyController.isStunned = false
	enemyController.guardCheck.currentAlertValue = stunEndAlertValue
	enemyController.guardCheck.resume_check()
	if (stunnedSound.playing): stunnedSound.stop()
