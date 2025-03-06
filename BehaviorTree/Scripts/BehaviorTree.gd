class_name BehaviorTree
extends Node

@export var root: BT_Node = null
	
func _process(delta):
	ExecuteBehaviorTree(delta)

func ExecuteBehaviorTree(delta):
	if (root != null):
		root.Evaluate(delta)
