class_name FoodCartCheckpoint
extends Area2D

@export var availableDirections: Array[bool]
@export var activated: bool = true

func Activate():
	activated = true

func Deactivate():
	activated = false
