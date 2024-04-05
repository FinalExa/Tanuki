extends InteractionObject

@export var neededTagForAttackInteraction: String

func attackInteraction(receivedTag):
	if (receivedTag == neededTagForAttackInteraction):
		get_parent().remove_child(self)
