class_name BehaviorTree
extends Node

@export var _root: BT_Node = null
	
func _process(_delta):
	ExecuteBehaviorTree()

func ExecuteBehaviorTree():
	if (_root!=null):
		_root.Evaluate()
