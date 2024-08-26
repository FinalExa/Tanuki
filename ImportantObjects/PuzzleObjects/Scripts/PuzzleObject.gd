class_name PuzzleObject
extends Node2D

@export var activated: bool

func _ready():
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
