class_name PlayerAttackHitbox
extends AttackHitbox

var attackTag: String

func _on_body_entered(body):
	check_if_target(body)

func check_if_target(body):
	if (body.is_in_group("Interactable")):
		body.AttackInteraction(attackTag)
		return
	if (body is EnemyController && !hitTargets.has(body)):
		body.IsRepelled(characterRef.global_position.direction_to(body.global_position))
		hitTargets.push_back(body)

func _on_area_entered(area):
	if (area.is_in_group("Interactable")):
		area.attackInteraction(attackTag)
