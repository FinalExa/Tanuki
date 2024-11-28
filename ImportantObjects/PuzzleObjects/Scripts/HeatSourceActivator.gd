extends PuzzleObject

@export var heatSourceRef: Node2D

func ReadyOperations():
	for i in heatSourceRef.get_child_count():
		if (heatSourceRef.get_child(i) is CollisionShape2D):
			collisionShapeRef = heatSourceRef.get_child(i)
			return
