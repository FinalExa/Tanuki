extends PuzzleObject

@export var attackTag: String

func Activation():
	if (get_parent() == null):
		call_deferred("AddChild")

func Deactivation():
	call_deferred("RemoveChild")

func AddChild():
	parentRef.add_child(self)

func RemoveChild():
	parentRef.remove_child(self)

func _on_body_entered(body):
	if (body.is_in_group("Interactable")):
		body.AttackInteraction(attackTag)
		return
	if (body is EnemyController):
		body.is_damaged(Vector2.ZERO)

func _on_area_entered(area):
	if (area.is_in_group("Interactable")):
		area.AttackInteraction(attackTag)
