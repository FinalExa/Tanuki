class_name PatrolIndexMove
extends PatrolIndex

@export var destination: NodePath

func ReturnDestination(patrolIndicator: PatrolIndicator):
	return patrolIndicator.get_node(destination)
