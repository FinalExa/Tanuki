class_name EnemyAttack
extends ExecuteAttack

func launch_attack():
	if (!attackLaunched):
		start_attack()

func _process(delta):
	attacking(delta)
