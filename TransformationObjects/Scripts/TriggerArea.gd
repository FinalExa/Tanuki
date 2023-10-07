extends Area2D

signal set_changeTrs_available

func _on_body_entered(body):
	emit_signal("set_changeTrs_available", true)

func _on_body_exited(body):
	emit_signal("set_changeTrs_available", false)
