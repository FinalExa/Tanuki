class_name BT_Node
extends Node

enum NodeState
{
	RUNNING,
	SUCCESS,
	FAILURE
}

var state: NodeState

var parent: BT_Node
var children = []

func _setNullParent():
	parent = null
	
func _setChildren(children):
	for i in children.size():
		_Attach(children[i])

func _Attach(node: BT_Node):
	node.parent = self
	children.push_back(node)

func Evaluate():
	return NodeState.FAILURE
