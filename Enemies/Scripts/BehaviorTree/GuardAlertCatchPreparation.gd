extends GuardNode

@export var guardAlert: GuardAlert

func Evaluate(delta):
	if (guardAlert.catchPreparationActive == true):
		if(guardAlert.catchPreparationTimer > 0):
			guardAlert.catchPreparationTimer -= delta
		else:
			guardAlert.capture_player()
	return NodeState.FAILURE
