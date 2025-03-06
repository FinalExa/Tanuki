extends InteractionObject

@export var neededTagForAttackInteraction: String

func attackInteraction(receivedTag):
	if (receivedTag == neededTagForAttackInteraction):
		SaveOnDestroy()
		queue_free()

func ExecuteLoadOperation():
	queue_free()
