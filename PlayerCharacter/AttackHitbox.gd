extends Area2D

var hitTargets: Array[Node2D]

func attack_end():
	hitTargets.clear()

func _on_body_entered(body):
	check_if_enemy(body)

func check_if_enemy(body):
	if (body is GuardController):
		body.is_damaged()
