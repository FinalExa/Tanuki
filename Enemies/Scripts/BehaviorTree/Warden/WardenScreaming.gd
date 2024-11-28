extends GuardNode

@export var wardenCheck: WardenCheck

func Evaluate(_delta):
	if (!wardenCheck.wardenAlertArea.activated):
		wardenCheck.AddArea()
	return NodeState.FAILURE
