class_name BehaviorTree
extends Node

var _root: BT_Node = null

func _ready():
	SetupTree()
	
func _process(delta):
	if (_root!=null):
		_root.Evaluate()

func SetupTree():
	pass
