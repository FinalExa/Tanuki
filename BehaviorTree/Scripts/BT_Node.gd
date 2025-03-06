class_name BT_Node
extends Node

enum NodeState
{
	FAILURE,
	SUCCESS,
	RUNNING
}

var state: NodeState

@export var children: Array[BT_Node]

func Evaluate(_delta):
	return NodeState.FAILURE
