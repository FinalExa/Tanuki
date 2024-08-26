extends PuzzleObject

var parentRef: Node2D

func Activation():
	if (get_parent() == null):
		call_deferred("AddChild")

func Deactivation():
	if (parentRef == null):
		parentRef = get_parent()
	call_deferred("RemoveChild")

func AddChild():
	parentRef.add_child(self)

func RemoveChild():
	parentRef.remove_child(self)

func _on_body_entered(body):
	if (body is EnemyController):
		body.is_damaged(Vector2.ZERO)
