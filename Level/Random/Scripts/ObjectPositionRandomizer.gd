extends Node2D

@export var objectsToRandomizePosition: Array[Node2D]
@export var positions: Array[Node2D]

func _ready():
	RandomizePositions()

func RandomizePositions():
	if (objectsToRandomizePosition.size() > 0 && positions.size() >= objectsToRandomizePosition.size()):
		var randomIndex: int
		for i in objectsToRandomizePosition.size():
			randomIndex = randi_range(0, positions.size() - 1)
			objectsToRandomizePosition[i].global_position = positions[randomIndex].global_position
			positions.remove_at(randomIndex)
			if (positions.size() == 0):
				break
