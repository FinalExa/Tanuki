class_name GuardResearch
extends Node

@export var researchActiveText: String
var researchTarget: Node2D

@export var guardController: GuardController
@export var guardAlertValue: GuardAlertValue
@export var guardMovement: GuardMovement
@export var guardRotator: GuardRotator

func  _process(delta):
	research_active()

func initialize_guard_research(target: Node2D):
	researchTarget = target
	guardController.isInResearch = true
	guardAlertValue.updateText(researchActiveText)

func research_active():
	if (guardController.isInResearch):
		print("In research")
