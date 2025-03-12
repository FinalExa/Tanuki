class_name TransformationSprite
extends Sprite2D

@export var transformationChange: TransformationChange

var baseTextureInfo: SpriteFrames
var baseTextureScale: Vector2
var startRotationDegrees: float

func Startup():
	baseTextureInfo = transformationChange.playerSprite.sprite_frames
	baseTextureScale = transformationChange.playerSprite.scale
	hide()
	startRotationDegrees = global_rotation_degrees

func FlipTransformationSprite():
	if (transformationChange.playerRef.velocity.x == 0):
		return
	if (transformationChange.playerRef.velocity.x > 0):
		self.flip_h = false
		return
	self.flip_h = true

func ActivateTransformationSpriteOperations():
	transformationChange.playerSprite.hide()
	show()

func DeactivateTransformationSpriteOperations():
	hide()
	transformationChange.playerSprite.show()

func KeepFixedImageRotation():
	if (global_rotation_degrees != startRotationDegrees):
		global_rotation_degrees = startRotationDegrees
