extends Node2D

signal change_speed
signal reset_speed

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
var transformationTimer

@export var transformationLockDuration = 0
var transformationLockTimer
var transformationLock = false

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
		print(currentTransformationName)

func activate_transformation():
	if (Input.is_action_just_pressed("transformation") && currentTransformationSet && !isTransformed && !transformationLock):
		print("IT'S MORBIN' TIME")
		transformationTimer = 0
		emit_signal("change_speed", currentTransformationSpeed)
		isTransformed = true
		transformation_lock_activate()

func manual_deactivate_transformation():
	if (Input.is_action_just_pressed("transformation") && isTransformed && !transformationLock):
		deactivate_transformation()

func deactivate_transformation():
	print("Morbin time over...")
	emit_signal("reset_speed")
	isTransformed = false
	transformation_lock_activate()

func transformation_active(delta):
	if (isTransformed):
		if (transformationTimer<transformationDuration):
			transformationTimer+=delta
			# if(transformationTimer>=tailActivationTime):
				#activate tail
		else:
			deactivate_transformation()

func transformation_lock_activate():
	transformationLock = true
	transformationLockTimer = 0

func transformation_lock(delta):
	if (transformationLock):
		if (transformationLockTimer<transformationLockDuration):
			transformationLockTimer+=delta
		else: 
			transformationLock = false
