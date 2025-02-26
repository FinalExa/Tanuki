class_name EnemyAttack
extends ExecuteAttack

func launch_attack():
	if (!attackLaunched && !attackInCooldown):
		start_attack()

func ForceStopAttack():
	ForceEndAttack()
