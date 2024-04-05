extends AttackHitbox

@export var attackTag: String

func _on_body_entered(body):
	check_if_target(body)

func check_if_target(body):
	if (body.is_in_group("Interactable")):
		body.attackInteraction(attackTag)
		return
	if (body is GuardController):
		body.is_damaged(body.global_position.direction_to(self.global_position))


func _on_area_entered(area):
	if (area.is_in_group("Interactable")):
		area.attackInteraction(attackTag)
