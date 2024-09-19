extends GuardNode

@export var guardAlert: GuardAlert

func Evaluate(delta):
	if (guardAlert.catchPreparationActive):
		if(guardAlert.catchPreparationTimer > 0):
			guardAlert.catchPreparationTimer -= delta
		else:
			guardAlert.set_last_target_info(guardAlert.alertTarget)
			guardAlert.capture_player()
	return NodeState.FAILURE
