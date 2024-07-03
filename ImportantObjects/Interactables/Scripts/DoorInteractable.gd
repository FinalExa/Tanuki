extends GenericInteractable

@export var centralCollider: CollisionShape2D
@export var closedSprite: Sprite2D
@export var openSprite: Sprite2D

func FirstStartup():
	openSprite.hide()

func FinalState():
	closedSprite.hide()
	openSprite.show()
	centralCollider.queue_free()
