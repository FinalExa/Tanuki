extends GenericInteractable

@export var cartCheckpointToEdit: FoodCartCheckpoint
@export var directionToAdd: CartDirections

enum CartDirections
{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func FinalStateExtraExecution():
	EditCheckpoint()

func EditCheckpoint():
	if (cartCheckpointToEdit != null):
		cartCheckpointToEdit.availableDirections[directionToAdd] = true
