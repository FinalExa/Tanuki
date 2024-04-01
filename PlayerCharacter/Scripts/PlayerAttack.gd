class_name PlayerAttack
extends ExecuteAttack

func _process(delta):
	check_for_attack_input()
	attacking(delta)

func check_for_attack_input():
	if (!attackLaunched && Input.is_action_just_pressed("attack") && !characterRef.transformationChangeRef.isTransformed):
		launch_attack()

func launch_attack():
	start_attack()
