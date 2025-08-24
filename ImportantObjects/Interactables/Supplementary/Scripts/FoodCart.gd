class_name FoodCart
extends StaticBody2D

@export var directionObjects: Array[Node2D]
@export var launchAreas: Array[FoodCartLaunchArea]
@export var startingCheckpoint: FoodCartCheckpoint
@export var launchSpeed: float
var currentCheckpoint: FoodCartCheckpoint
var oldCheckPoint: FoodCartCheckpoint
var currentDirectionId: int
var directions: Array[Vector2]

func _ready():
	SetCheckpointReached(startingCheckpoint)
	CalculateDirections()

func _physics_process(delta):
	FoodCartState(delta)

func FoodCartState(delta):
	if (currentCheckpoint != null):
		if (self.global_position != currentCheckpoint.global_position):
			self.global_position = currentCheckpoint.global_position
	else:
		translate(directions[currentDirectionId] * launchSpeed * delta)

func CalculateDirections():
	for i in directionObjects.size():
		directions.push_back(self.global_position.direction_to(directionObjects[i].global_position))

func SetCheckpointReached(checkpoint: FoodCartCheckpoint):
	oldCheckPoint = null
	currentCheckpoint = checkpoint
	for i in currentCheckpoint.availableDirections.size():
		if (currentCheckpoint.availableDirections[i]):
			launchAreas[i].Activate()
			continue
		launchAreas[i].Deactivate()

func LaunchTo(id: int):
	oldCheckPoint = currentCheckpoint
	currentCheckpoint = null
	for i in launchAreas.size():
		launchAreas[i].Deactivate()
	currentDirectionId = id

func CheckForCheckpoints(area):
	if (area is FoodCartCheckpoint && area != oldCheckPoint && area.activated):
		SetCheckpointReached(area)
