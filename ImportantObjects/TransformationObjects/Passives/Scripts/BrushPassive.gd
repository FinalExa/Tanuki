class_name BrushPassive
extends TransformationObjectPassive

enum BrushColor
{
	RED,
	GREEN,
	BLUE,
	YELLOW,
	NONE
}

@export var defaultColor: BrushColor
@export var spriteRef: Sprite2D
@export var colors: Array[Color]
@export var tags: Array[String]
var currentColorYokaiIn: ColorYokai
var currentColor: BrushColor

func _process(delta):
	if (!transformationChangeRef.isTransformed):
		ChangeColor(defaultColor)
	else:
		if (currentColorYokaiIn != null): ChangeColor(currentColorYokaiIn.colorOfYokai)

func ChangeColor(colorToSet: BrushColor):
	if (colorToSet != currentColor):
		currentColor = colorToSet
		spriteRef.modulate = colors[colorToSet]
		transformationChangeRef.currentAttack.attackTag = tags[colorToSet]

func _on_new_color_check_body_entered(body):
	if (body is ColorYokai):
		currentColorYokaiIn = body


func _on_new_color_check_body_exited(body):
	if (body is ColorYokai && body == currentColorYokaiIn):
		currentColorYokaiIn = null
