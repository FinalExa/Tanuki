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
var currentColorYokaiIn: ColorYokai
var currentColor: BrushColor

func _process(_delta):
	if (!transformationChangeRef.isTransformed):
		if (self.visible): self.hide()
		ChangeColor(defaultColor)
	else:
		if (!self.visible): self.show()
		FollowBrushSprite()
		if (currentColorYokaiIn != null): ChangeColor(currentColorYokaiIn.colorOfYokai)

func FollowBrushSprite():
	spriteRef.global_position = transformationChangeRef.transformationSprite.global_position
	spriteRef.rotation_degrees = transformationChangeRef.transformationSprite.rotation_degrees
	spriteRef.flip_h = transformationChangeRef.transformationSprite.flip_h

func ChangeColor(colorToSet: BrushColor):
	if (colorToSet != currentColor):
		currentColor = colorToSet
		spriteRef.modulate = colors[colorToSet]
		for i in transformationChangeRef.currentAttack.attackHitboxes.size():
			if (transformationChangeRef.currentAttack.attackHitboxes[i] != null && transformationChangeRef.currentAttack.attackHitboxes[i] is AttackHitbox):
				transformationChangeRef.currentAttack.attackHitboxes[i].modulate = colors[colorToSet]

func ColorYokaiIn(ref):
	if (ref is ColorYokai):
		currentColorYokaiIn = ref

func ColorYokaiOut(ref):
	if (ref is ColorYokai && ref == currentColorYokaiIn):
		currentColorYokaiIn = null
