extends InteractionObject

@export var neededTagForAttackInteraction: String

func attackInteraction(receivedTag):
	if (receivedTag == neededTagForAttackInteraction):
		SaveOnDestroy()
		get_parent().remove_child(self)

func ExecuteLoadOperation():
	get_parent().remove_child(self)
