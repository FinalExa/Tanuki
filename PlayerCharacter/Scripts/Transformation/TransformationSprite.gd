class_name TransformationSprite
extends Sprite2D

@export var transformationChange: TransformationChange
@export var baseColor: Color
@export var transformationSpriteColorDuringMovement: Color
@export var playerSpriteColorDuringMovement: Color

var baseTextureInfo: SpriteFrames
var baseTextureScale: Vector2
var startRotationDegrees: float

func Startup():
	baseTextureInfo = transformationChange.playerSprite.sprite_frames
	baseTextureScale = transformationChange.playerSprite.scale
	hide()
	startRotationDegrees = global_rotation_degrees

func TransformationSpriteDuringTransformationOperations():
	if (transformationChange.isTransformed):
		if (transformationChange.playerRef.velocity != Vector2.ZERO):
			self.modulate = transformationSpriteColorDuringMovement
			transformationChange.playerSprite.modulate = playerSpriteColorDuringMovement
			transformationChange.playerSprite.show()
			return
		self.modulate = baseColor
		transformationChange.playerSprite.hide()

func FlipTransformationSprite():
	if (transformationChange.playerRef.velocity.x == 0):
		return
	if (transformationChange.playerRef.velocity.x > 0):
		self.flip_h = false
		return
	self.flip_h = true

func ActivateTransformationSpriteOperations():
	transformationChange.playerSprite.hide()
	self.show()

func DeactivateTransformationSpriteOperations():
	self.hide()
	self.modulate = baseColor
	transformationChange.playerSprite.show()
	transformationChange.playerSprite.modulate = baseColor

func KeepFixedImageRotation():
	if (global_rotation_degrees != startRotationDegrees):
		global_rotation_degrees = startRotationDegrees
