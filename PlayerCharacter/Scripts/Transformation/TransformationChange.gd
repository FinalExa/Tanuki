class_name TransformationChange
extends Node2D

signal change_speed
signal reset_speed
signal send_transformation_texture
signal send_transformation_has_attack
signal send_transformation_active_info

var transformObjectsInRange: Array[TransformationObjectData]

var currentTransformationObject: TransformationObjectData
var currentOriginalObjectPath: String
var currentTransformationSet: bool
var currentTransformationPassive: TransformationObjectPassive

var currentAttack: ExecuteAttack

var isTransformed: bool = false
@export var playerRef: PlayerCharacter
@export var transformationSounds: TransformationSounds
@export var transformationOriginalObject: TransformationOriginalObject
@export var transformationSprite: TransformationSprite
@export var trasformationUndetectable: TrasformationUndetectable
@export var transformationDuration: float
@export var lowTimeRemaining: float
@export var baseCollisionShape: CollisionShape2D
@export var playerSprite: AnimatedSprite2D
@export var noTransformationText: String
@export var transformationObjectSafeCoords: Vector2
@export var transformationAttackTimerCost: float

var undetectable: bool
var transformationTimer: float
var baseCollisionShapeInfo: Shape2D

@export var transformationLockDuration: float
var transformationLockTimer: float
var transformationLock: bool

var sceneRef: Node2D
var localAllowedItemsRef: Array[LocalAllowedItems]

func _ready():
	InitialSetup()

func InitialSetup():
	baseCollisionShapeInfo = baseCollisionShape.shape
	transformationSprite.Startup()
	emit_signal("send_transformation_active_info", transformationTimer, transformationDuration)

func _process(delta):
	transformationSprite.FlipTransformationSprite()
	SetNewTransformation()
	ActivateTransformation()
	CheckForDeactivateTransformation()
	TransformationActive(delta)
	LockTimer(delta)
	CheckForAttackInput()
	trasformationUndetectable.UndetectableTimer(delta)

func SetTransformationObjectInRange(trsObjectRef: TransformationObjectData):
	if (!transformObjectsInRange.has(trsObjectRef)):
		transformObjectsInRange.push_back(trsObjectRef)

func UnsetTransformationObjectInRange(trsObjectRef: TransformationObjectData):
	if (transformObjectsInRange.has(trsObjectRef)):
		transformObjectsInRange.erase(trsObjectRef)

func SetNewTransformation():
	if (playerRef.playerInputs.interactInput && transformObjectsInRange.size() > 0 && !isTransformed):
		SaveNewTransformation(transformObjectsInRange[transformObjectsInRange.size() - 1])
		transformationSounds.PlayObjectSavedSound()
		emit_signal("send_transformation_active_info", transformationTimer, transformationDuration)

func SaveNewTransformation(trsObjectToSave: TransformationObjectData):
	if (trsObjectToSave.scene_file_path != currentOriginalObjectPath):
		transformationTimer = 0
	currentTransformationSet = true
	currentOriginalObjectPath = trsObjectToSave.scene_file_path
	transformationOriginalObject.GenerateTransformationObject()
	emit_signal("send_transformation_texture", currentTransformationObject.transformedTexture.texture.resource_path)

func SetNoTransformation():
	currentTransformationSet = false
	if (currentTransformationObject != null):
		currentTransformationObject.queue_free()
	transformationTimer = 0
	emit_signal("send_transformation_texture", "")
	emit_signal("send_transformation_active_info", transformationTimer, 1)

func ActivateTransformation():
	if (playerRef.playerInputs.transformInput && currentTransformationSet && !isTransformed && !transformationLock):
		transformationOriginalObject.GenerateTransformationObject()
		TransformationFeedbackActivation(true)
		if (currentTransformationObject.transformedAttackPath != ""):
			emit_signal("send_transformation_has_attack", true)
		else:
			emit_signal("send_transformation_has_attack", false)
		transformationSounds.PlayEnterTransformationSound()
		var savedLocalAreas: Array[LocalAllowedItems]
		if (localAllowedItemsRef.size() > 0): savedLocalAreas = localAllowedItemsRef
		baseCollisionShape.shape = currentTransformationObject.transformedCollider.shape
		if (savedLocalAreas.size() > 0): 
			for i in savedLocalAreas.size():
				savedLocalAreas[i]._on_body_entered(playerRef)
		transformationSprite.ActivateTransformationSpriteOperations()
		emit_signal("change_speed", currentTransformationObject.transformedSpeedTier)
		isTransformed = true
		ActivateLock()
		trasformationUndetectable.UndetectableActivate()

func CheckForDeactivateTransformation():
	if (playerRef.playerInputs.transformInput && isTransformed && !transformationLock):
		call_deferred("DeactivateTransformation")

func DeactivateTransformation():
	TransformationFeedbackActivation(false)
	emit_signal("reset_speed")
	emit_signal("send_transformation_has_attack", true)
	transformationSounds.PlayDeactivateTransformation()
	if (playerRef.transformationInvincibility): playerRef.transformationInvincibility = false
	baseCollisionShape.shape = baseCollisionShapeInfo
	transformationSprite.DeactivateTransformationSpriteOperations()
	isTransformed = false
	ActivateLock()

func TransformationActive(delta):
	if (isTransformed):
		transformationSprite.KeepFixedImageRotation()
		if (transformationTimer < transformationDuration):
			transformationTimer = clamp(transformationTimer + delta, 0, transformationDuration)
			transformationSounds.PlayTransformationLowSound()
		else:
			DeactivateTransformation()
			SetNoTransformation()
		emit_signal("send_transformation_active_info", transformationTimer, transformationDuration)

func ActivateLock():
	transformationLock = true
	transformationLockTimer = 0

func LockTimer(delta):
	if (transformationLock):
		if (transformationLockTimer < transformationLockDuration):
			transformationLockTimer += delta
		else:
			transformationLock = false

func SetLocalZone(localRef: LocalAllowedItems):
	if (!localAllowedItemsRef.has(localRef)):
		localAllowedItemsRef.push_back(localRef)

func UnsetLocalZone(localRef: LocalAllowedItems):
	if (localAllowedItemsRef.has(localRef)):
		localAllowedItemsRef.erase(localRef)

func get_if_transformed_in_right_zone():
	if (undetectable): return 1
	if (isTransformed):
		if (localAllowedItemsRef != null):
			for i in localAllowedItemsRef.size():
				if (localAllowedItemsRef[i].allowedObjects.has(currentTransformationObject.transformedName)):
					return 1
		return 2
	return 0

func CheckForAttackInput():
	if (isTransformed && currentAttack != null && !currentAttack.attackLaunched && !currentAttack.attackInCooldown && playerRef.playerInputs.attackInput):
		currentAttack.start_attack()

func TransformationFeedbackActivation(status: bool):
	get_tree().root.get_child(0).sceneSelector.currentScene.ActivateOrDeactivateFeedbackForLocalAllowedItems(currentTransformationObject.transformedName, status)

func _on_player_character_transformation_invincibility_interacted(receivedNode: Node2D):
	if (currentTransformationPassive != null):
		currentTransformationPassive.TransformationInvincibilityInteracted(receivedNode)

func DeactivateObjectToOperate(objectToOperate: Node2D):
	if (objectToOperate is PuzzleObject):
		objectToOperate.Deactivation()
		return
	objectToOperate.hide()
	for i in objectToOperate.get_child_count():
		if (objectToOperate.get_child(i) is CollisionShape2D || objectToOperate.get_child(i) is CollisionPolygon2D):
			objectToOperate.get_child(i).disabled = true

func AttackDetractTimer():
	if (isTransformed):
		transformationTimer = clamp(transformationTimer + transformationAttackTimerCost, 0, transformationDuration)
