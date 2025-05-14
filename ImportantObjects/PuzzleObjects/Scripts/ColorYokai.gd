class_name ColorYokai
extends PuzzleObject

@export var colorOfYokai: BrushPassive.BrushColor
@export var spriteRef: Sprite2D
@export var colors: Array[Color]

func ReadyOperations():
	spriteRef.modulate = colors[colorOfYokai]
