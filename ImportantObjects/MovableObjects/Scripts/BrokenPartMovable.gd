class_name GeneratorPartMovable
extends MovableObject

@export var partID: int
@export var partSprites: Array[Sprite2D]

func ReadyOperations():
	partSprites[partID].show()
