extends GuardNode

@export var guardPatrol: GuardPatrol

func Evaluate(_delta):
	return wait_for_rotation()

func wait_for_rotation():
	if (guardPatrol.isRotating):
		if (guardController.guardRotator.isDoneRotating):
			guardPatrol.set_current_patrol_routine()
			guardPatrol.isRotating = false
	return NodeState.SUCCESS
