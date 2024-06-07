extends Area2D

func _on_body_entered(body):
	if (body is HyottokoController):
		body.SetInRage()


func _on_body_exited(body):
	if (body is HyottokoController):
		body.SetOutOfRage()
