extends GuardNode

@export var wardenCheck: WardenCheck

func Evaluate(_delta):
	if (wardenCheck.wardenAlertArea.get_parent() == null):
		wardenCheck.AddArea()
	return NodeState.FAILURE
