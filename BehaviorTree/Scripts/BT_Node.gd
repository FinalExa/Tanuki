class_name BT_Node
extends Node

enum NodeState
{
	RUNNING,
	SUCCESS,
	FAILURE
}

var state: NodeState

@export var children: Array[BT_Node]

func Evaluate(delta):
	return NodeState.FAILURE
