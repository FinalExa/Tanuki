class_name TrapObjectEffect
extends Node2D

var launchedOnEnter: bool = false

func Startup():
	pass

func AlternativeStartup():
	Startup()

func NormalEffect(_receivedBody: CharacterBody2D, _delta):
	pass

func NegatedEffect(_receivedBody: CharacterBody2D, _delta):
	pass

func OnEnterEffect(_receivedbody: CharacterBody2D):
	pass

func OnLeaveEffect(_receivedBody: CharacterBody2D):
	pass
