extends TrapObjectEffect

@export var movementDistancePerTick: float
@export var directionStartPoint: Node2D
@export var directionEndPoint: Node2D
@export var arrowSprite: Node2D
var direction: Vector2

func _ready():
	GetDirection()
	arrowSprite.hide()

func GetDirection():
	direction = directionStartPoint.global_position.direction_to(directionEndPoint.global_position)

func NormalEffect(receivedBody: CharacterBody2D, _delta):
	receivedBody.velocity = direction * movementDistancePerTick
	if (receivedBody is PlayerCharacter):
		receivedBody.playerMoveObjects.ForceDropMovableObject()
