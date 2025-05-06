class_name GuardStunned
extends EnemyStunned

func end_stun():
	enemyController.enemyRotator.setLookingAtPosition((lookDirectionAfterStun * 10) + enemyController.global_position)
	enemyController.isStunned = false
	enemyController.guardCheck.currentAlertValue = stunEndAlertValue
	enemyController.guardCheck.resume_check()
	enemyController.guardCheck.checkTarget = get_tree().root.get_child(0).playerRef
	if (stunnedSound.playing): stunnedSound.stop()
