class_name ActivateOnEnemyStun
extends Node2D

var done: bool

func CheckForActivation():
	if (!done):
		ExecuteEffect()
		self.hide()
		done = true

func ExecuteEffect():
	pass
