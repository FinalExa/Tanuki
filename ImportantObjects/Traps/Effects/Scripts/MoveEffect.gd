extends InteractionObjectEffect
@export var movementDistancePerTick: float
@export var directionStartPoint: Node2D
@export var directionEndPoint: Node2D
var direction: Vector2

func _ready():
	calculate_direction()

func calculate_direction():
	direction = directionStartPoint.global_position.direction_to(directionEndPoint.global_position)

func execute_effect_normally(receivedBody: CharacterBody2D, delta):
	receivedBody.translate(direction*movementDistancePerTick*delta)
