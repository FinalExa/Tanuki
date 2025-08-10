extends GenericInteractable

func _on_body_entered(body):
	if (visible && body is HyottokoController):
		FinalState()
