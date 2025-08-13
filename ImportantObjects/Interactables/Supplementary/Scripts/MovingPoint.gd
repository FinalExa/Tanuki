class_name MovingPoint
extends Node2D

@export var alwaysActive: bool
@export var objectToMove: Node2D
@export var speed: float
@export var distanceTolerance: float
@export var path: Array[Node2D]
var pathStarted: bool
var pathIndex: int

func _ready():
	EndPath()

func _physics_process(delta):
	if (alwaysActive && !pathStarted): StartPath()
	MoveObject(delta)

func StartPath():
	pathStarted = true

func EndPath():
	pathStarted = false
	pathIndex = 0

func MoveObject(delta):
	if (pathStarted):
		if (pathIndex < path.size()):
			if (objectToMove.global_position.distance_to(path[pathIndex].global_position) > distanceTolerance):
				objectToMove.translate(objectToMove.global_position.direction_to(path[pathIndex].global_position) * speed * delta)
			else:
				pathIndex += 1
