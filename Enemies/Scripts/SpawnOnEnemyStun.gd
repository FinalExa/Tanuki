extends ActivateOnEnemyStun

@export var objectToSpawn: String
@export var objectParent: Node2D
@export var objectSpawnPosition: Node2D

func ExecuteEffect():
	call_deferred("SpawnAndAssignObject")

func SpawnAndAssignObject():
	var object: Node2D = load(objectToSpawn).instantiate()
	objectParent.add_child(object)
	object.global_position = objectSpawnPosition.global_position
