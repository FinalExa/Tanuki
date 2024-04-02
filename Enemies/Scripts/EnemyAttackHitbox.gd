extends AttackHitbox

func _on_body_entered(body):
	if (body is PlayerCharacter):
		get_tree().reload_current_scene()
