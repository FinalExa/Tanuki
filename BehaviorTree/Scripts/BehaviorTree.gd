class_name BehaviorTree
extends Node

@export var _root: BT_Node = null
	
func _process(_delta):
	ExecuteBehaviorTree(delta)

func ExecuteBehaviorTree(delta):
	if (_root!=null):
		_root.Evaluate(delta)
