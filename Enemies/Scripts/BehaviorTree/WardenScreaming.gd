extends GuardNode

@export var wardenCheck: WardenCheck

func Evaluate(_delta):
	if (wardenCheck.alertGuardsArea.get_parent() == null):
		wardenCheck.AddArea()
	return NodeState.FAILURE
