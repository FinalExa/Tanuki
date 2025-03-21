extends GuardNode

@export var wardenCheck: WardenCheck

func Evaluate(delta):
	wardenCheck.IncreaseCheckValue(delta)
	if (wardenCheck.checkCurrentValue >= wardenCheck.checkScreamThreshold):
		return NodeState.SUCCESS
	else:
		if (wardenCheck.wardenAlertArea.get_parent() == wardenCheck):
			wardenCheck.RemoveArea()
	return NodeState.FAILURE
