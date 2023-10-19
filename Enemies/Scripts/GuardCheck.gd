class_name GuardCheck
extends Area2D

@export var isChecking: bool
@export var maxAlertValue: float
@export var playerOrTailIsSeenMultiplier: float
@export var playerOrTailIsNotSeenMultiplier: float
@export var distanceMultiplier: float
var currentAlertValue: float

@export var guardAlertValue: GuardAlertValue

func _ready():
	pass

func reset_alert_value():
	currentAlertValue = 0
	isChecking = false
