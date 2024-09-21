class_name PuzzleObject
extends Node2D

@export var activated: bool
var parentRef: Node2D

func _ready():
	parentRef = get_parent()
	ExecuteActivationStatus()

func InteractSignal():
	activated = !activated
	ExecuteActivationStatus()

func ExecuteActivationStatus():
	if (activated):
		Activation()
		return
	Deactivation()

func Activation():
	pass

func Deactivation():
	pass
