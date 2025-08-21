class_name TransformationSaving
extends Sprite2D

@export var transformationChange: TransformationChange
var transformObjectsInRange: Array[TransformationObjectData]
var startDegrees: float

func _ready():
	startDegrees = global_rotation_degrees

func SetTransformationObjectInRange(trsObjectRef: TransformationObjectData):
	if (!transformObjectsInRange.has(trsObjectRef)):
		transformObjectsInRange.push_back(trsObjectRef)

func UnsetTransformationObjectInRange(trsObjectRef: TransformationObjectData):
	if (transformObjectsInRange.has(trsObjectRef)):
		transformObjectsInRange.erase(trsObjectRef)

func SetNewTransformation():
	if (transformationChange.playerRef.playerInputs.obtainTransformationInput && transformObjectsInRange.size() > 0 && !transformationChange.isTransformed):
		SaveNewTransformation(transformObjectsInRange[transformObjectsInRange.size() - 1])
		transformationChange.transformationSounds.PlayObjectSavedSound()
		transformationChange.emit_signal("send_transformation_active_info", transformationChange.transformationTimer, transformationChange.transformationDuration, transformationChange.currentTransformationObject.transformedName)

func SaveNewTransformation(trsObjectToSave: TransformationObjectData):
	transformationChange.transformationTimer = 0
	transformationChange.currentTransformationSet = true
	transformationChange.currentOriginalObjectPath = trsObjectToSave.scene_file_path
	transformationChange.transformationOriginalObject.GenerateTransformationObject()
	transformationChange.emit_signal("send_transformation_texture", transformationChange.currentTransformationObject.transformedTexture.texture.resource_path)

func SetNoTransformation():
	transformationChange.currentTransformationSet = false
	if (transformationChange.currentTransformationObject != null):
		transformationChange.currentTransformationObject.queue_free()
	transformationChange.transformationTimer = 0
	transformationChange.emit_signal("send_transformation_texture", "")
	transformationChange.emit_signal("send_transformation_active_info", transformationChange.transformationTimer, 1, transformationChange.noTransformationText)

func TransformationSavedSpriteUpdate():
	if (transformationChange.currentTransformationSet && !transformationChange.isTransformed):
		if (!self.visible):
			self.show()
		self.global_rotation_degrees = startDegrees
		return
	self.hide()
