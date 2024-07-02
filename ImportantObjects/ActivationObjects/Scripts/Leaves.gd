extends StaticBody2D

@export var transformationDuration: float
@export var transformationGroup: String
@export var offSprite: Sprite2D
@export var onSprite: Sprite2D
var transformed: bool
var transformationTimer: float
var playerRef: PlayerCharacter

func _ready():
	RemoveTransformation()

func _process(delta):
	ActivateTransformation()
	Transformation(delta)

func ActivateTransformation():
	if (playerRef != null && playerRef.playerInputs.interactInput):
		StartTransformation()

func Transformation(delta):
	if (transformed):
		if (transformationTimer > 0):
			transformationTimer -= delta
		else:
			RemoveTransformation()

func StartTransformation():
	if (!self.is_in_group(transformationGroup)):
		self.add_to_group(transformationGroup)
	transformationTimer = transformationDuration
	transformed = true
	offSprite.hide()
	onSprite.show()

func RemoveTransformation():
	self.remove_from_group(transformationGroup)
	transformed = false
	offSprite.show()
	onSprite.hide()

func _on_leaves_interact_area_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body

func _on_leaves_interact_area_body_exited(body):
	if (body is PlayerCharacter):
		playerRef = null
