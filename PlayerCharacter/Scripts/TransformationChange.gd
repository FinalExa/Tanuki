extends Node2D

signal change_speed
signal reset_speed
signal send_transformation_name
signal send_transformation_active_info

var isInsidePossibleTransformationObject
var tempTransformationName
var tempTransformationSpeed
var tempTransformationProperties

var currentTransformationSet
var currentTransformationName
var currentTransformationSpeed
var currentTransformationProperties

var isTransformed
@export var transformationDuration = 0
@export var tailActivationTime = 0
@export var timeRefundOnReactivation = 0
var tailReference
var tailInstance
var transformationTimer

@export var transformationLockDuration = 0
var transformationLockTimer
var transformationLock = false

func _ready():
	transformationTimer = 0
	tailReference = self.get_child(0)
	tailInstance = self.get_child(0)
	self.remove_child(tailInstance)

func _process(delta):
	set_new_transformation()
	activate_transformation()
	manual_deactivate_transformation()
	transformation_active(delta)
	transformation_lock(delta)

func _on_player_character_set_temp_trs(tempName, tempSpeed, tempProperties):
	isInsidePossibleTransformationObject = true
	tempTransformationName = tempName
	tempTransformationSpeed = tempSpeed
	tempTransformationProperties = tempProperties

func _on_player_character_unset_temp_trs():
	isInsidePossibleTransformationObject = false

func set_new_transformation():
	if (Input.is_action_just_pressed("interact") && isInsidePossibleTransformationObject):
		currentTransformationSet = true
		currentTransformationName = tempTransformationName
		currentTransformationSpeed = tempTransformationSpeed
		currentTransformationProperties = tempTransformationProperties
		emit_signal("send_transformation_name", currentTransformationName)

func activate_transformation():
	if (Input.is_action_just_pressed("transformation") && currentTransformationSet && !isTransformed && !transformationLock):
		transformationTimer=clamp(transformationTimer-timeRefundOnReactivation,0,transformationDuration)
		emit_signal("change_speed", currentTransformationSpeed)
		isTransformed = true
		transformation_lock_activate()

func manual_deactivate_transformation():
	if (Input.is_action_just_pressed("transformation") && isTransformed && !transformationLock):
		deactivate_transformation()

func deactivate_transformation():
	emit_signal("reset_speed")
	isTransformed = false
	if (self.get_child_count()>0):
		self.remove_child(tailInstance)
	transformation_lock_activate()

func transformation_active(delta):
	if (isTransformed):
		if (transformationTimer<transformationDuration):
			transformationTimer=clamp(transformationTimer+delta,0,transformationDuration)
			if(transformationTimer>=tailActivationTime && self.get_child_count() == 0):
				add_child(tailReference)
				tailInstance = self.get_child(0)
		else:
			deactivate_transformation()
	else:
		if (transformationTimer>0):
			transformationTimer=clamp(transformationTimer-delta,0,transformationDuration)
	emit_signal("send_transformation_active_info", isTransformed, transformationTimer, transformationDuration)

func transformation_lock_activate():
	transformationLock = true
	transformationLockTimer = 0

func transformation_lock(delta):
	if (transformationLock):
		if (transformationLockTimer<transformationLockDuration):
			transformationLockTimer+=delta
		else:
			transformationLock = false
