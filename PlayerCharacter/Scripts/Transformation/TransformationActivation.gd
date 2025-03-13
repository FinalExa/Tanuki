class_name TransformationActivation
extends Node

@export var transformationChange: TransformationChange

func ActivateTransformation():
	if (transformationChange.playerRef.playerInputs.transformInput && transformationChange.currentTransformationSet && !transformationChange.isTransformed && !transformationChange.transformationLocked):
		transformationChange.transformationOriginalObject.GenerateTransformationObject()
		TransformationFeedbackActivation(true)
		if (transformationChange.currentTransformationObject.transformedAttackPath != ""):
			transformationChange.emit_signal("send_transformation_has_attack", true)
		else:
			transformationChange.emit_signal("send_transformation_has_attack", false)
		transformationChange.transformationSounds.PlayEnterTransformationSound()
		var savedLocalAreas: Array[LocalAllowedItems]
		if (transformationChange.localAllowedItemsRef.size() > 0):
			savedLocalAreas = transformationChange.localAllowedItemsRef
		transformationChange.baseCollisionShape.shape = transformationChange.currentTransformationObject.transformedCollider.shape
		if (savedLocalAreas.size() > 0): 
			for i in savedLocalAreas.size():
				savedLocalAreas[i]._on_body_entered(transformationChange.playerRef)
		transformationChange.transformationSprite.ActivateTransformationSpriteOperations()
		transformationChange.emit_signal("change_speed", transformationChange.currentTransformationObject.transformedSpeedTier)
		transformationChange.isTransformed = true
		transformationChange.transformationLock.ActivateLock()
		transformationChange.trasformationUndetectable.UndetectableActivate()

func CheckForDeactivateTransformation():
	if (transformationChange.playerRef.playerInputs.transformInput && transformationChange.isTransformed && !transformationChange.transformationLocked):
		call_deferred("DeactivateTransformation")

func DeactivateTransformation():
	TransformationFeedbackActivation(false)
	transformationChange.emit_signal("reset_speed")
	transformationChange.emit_signal("send_transformation_has_attack", true)
	transformationChange.transformationSounds.PlayDeactivateTransformation()
	if (transformationChange.playerRef.transformationInvincibility):
		transformationChange.playerRef.transformationInvincibility = false
	transformationChange.baseCollisionShape.shape = transformationChange.baseCollisionShapeInfo
	transformationChange.transformationSprite.DeactivateTransformationSpriteOperations()
	transformationChange.isTransformed = false
	transformationChange.transformationLock.ActivateLock()

func TransformationActive(delta):
	if (transformationChange.isTransformed):
		transformationChange.transformationSprite.KeepFixedImageRotation()
		if (transformationChange.transformationTimer < transformationChange.transformationDuration):
			transformationChange.transformationTimer = clamp(transformationChange.transformationTimer + (delta * transformationChange.currentTransformationObject.transformedTimeConsumption), 0, transformationChange.transformationDuration)
			transformationChange.transformationSounds.PlayTransformationLowSound()
		else:
			call_deferred("DeactivateTransformation")
			transformationChange.SetNoTransformation()
		transformationChange.emit_signal("send_transformation_active_info", transformationChange.transformationTimer, transformationChange.transformationDuration)

func TransformationFeedbackActivation(status: bool):
	get_tree().root.get_child(0).sceneSelector.currentScene.ActivateOrDeactivateFeedbackForLocalAllowedItems(transformationChange.currentTransformationObject.transformedName, status)
