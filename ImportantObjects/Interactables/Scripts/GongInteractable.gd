extends GenericInteractable

func ExecuteRefEffect(receivedRef):
	if (receivedRef is EnemyController):
		receivedRef.isRepelled = false
		receivedRef.is_damaged(Vector2.ZERO)
