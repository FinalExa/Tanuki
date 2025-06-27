class_name TransformationOriginalObject
extends Node

@export var transformationChange: TransformationChange

func GenerateTransformationObject():
	if (transformationChange.currentTransformationObject == null || (transformationChange.currentOriginalObjectPath != transformationChange.currentTransformationObject.scene_file_path)):
		call_deferred("Generate")
	call_deferred("SendTexture")

func Generate():
	if (transformationChange.currentTransformationObject != null && transformationChange.currentOriginalObjectPath != transformationChange.currentTransformationObject.scene_file_path):
		var oldObjectToDelete: TransformationObjectData = transformationChange.currentTransformationObject
		oldObjectToDelete.queue_free()
	transformationChange.currentTransformationObject = InstantiateScene(transformationChange.currentOriginalObjectPath)
	transformationChange.currentTransformationObject.reparent(get_tree().root.get_child(0).sceneSelector.currentScene)
	transformationChange.currentTransformationObject.global_position = transformationChange.transformationObjectSafeCoords
	transformationChange.DeactivateObjectToOperate(transformationChange.currentTransformationObject)
	transformationChange.transformationSprite.texture = transformationChange.currentTransformationObject.transformedTexture.texture
	transformationChange.transformationSprite.scale = transformationChange.currentTransformationObject.transformedTextureScale
	transformationChange.currentAttack = SpawnTransformationSpecialObject(transformationChange.currentTransformationObject.transformedAttackPath, transformationChange.currentAttack)
	SetupSpawnedItem(transformationChange.currentAttack)
	transformationChange.currentTransformationPassive = SpawnTransformationSpecialObject(transformationChange.currentTransformationObject.transformedPassivePath, transformationChange.currentTransformationPassive)
	SetupSpawnedItem(transformationChange.currentTransformationPassive)
	if (transformationChange.currentTransformationPassive != null):
		transformationChange.currentTransformationPassive.SetTransformationChangeRef(transformationChange)

func SendTexture():
	transformationChange.emit_signal("send_transformation_texture", transformationChange.currentTransformationObject.transformedTexture.texture.resource_path)

func InstantiateScene(path: String):
	var scene = load(path)
	var ref = scene.instantiate()
	add_child(ref)
	return ref

func SpawnTransformationSpecialObject(path: String, object: Node2D):
	if (object != null):
		if (object.get_parent() != null):
			object.get_parent().remove_child(object)
		if (object is ExecuteAttack):
			object.frameMaster.RemoveAttack(object)
		object.queue_free()
		object = null
	if (path != ""):
		object = InstantiateScene(path)
		object.characterRef = transformationChange.playerRef
	return object

func SetupSpawnedItem(spawnedItem: Node2D):
	if (spawnedItem != null):
		spawnedItem.reparent(transformationChange)
		spawnedItem.position = Vector2.ZERO
		spawnedItem.global_rotation_degrees = transformationChange.playerRef.GetRotator().global_rotation_degrees

func InvincibilityInteracted(receivedNode: Node2D):
	if (transformationChange.currentTransformationPassive != null):
		transformationChange.currentTransformationPassive.TransformationInvincibilityInteracted(receivedNode)
