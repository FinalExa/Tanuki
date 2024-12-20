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
var guardsLookingForMe: Array[GuardResearch]

var isTransformed: bool = false
@export var transformationDuration: float
@export var lowTimeRemaining: float
@export var playerRef: PlayerCharacter
@export var baseCollisionShape: CollisionShape2D
@export var playerSprite: AnimatedSprite2D
@export var enterTransformationSound: AudioStreamPlayer
@export var exitTransformationSound: AudioStreamPlayer
@export var playerTransformedSprite: Sprite2D
@export var objectSavedSound: AudioStreamPlayer
@export var transformationTimeLowSound: AudioStreamPlayer
@export var noTransformationText: String
@export var transformationObjectSafeCoords: Vector2
@export var transformationAttackTimerCost: float
var baseCollisionShapeInfo
var baseTextureInfo: SpriteFrames
var baseTextureScale: Vector2
var transformationTimer: float

@export var transformationLockDuration: float
var transformationLockTimer: float
var transformationLock: bool
var timeLowSoundPlayed: bool

var sceneRef: Node2D
var localAllowedItemsRef: LocalAllowedItems

func _ready():
	InitialSetup()

func InitialSetup():
	baseCollisionShapeInfo = baseCollisionShape.shape
	baseTextureInfo = playerSprite.sprite_frames
	baseTextureScale = playerSprite.scale
	playerTransformedSprite.hide()
	emit_signal("send_transformation_active_info", transformationTimer, transformationDuration)

func _process(delta):
	SetNewTransformation()
	ActivateTransformation()
	CheckForDeactivateTransformation()
	TransformationActive(delta)
	LockTimer(delta)
	CheckForAttackInput()

func SetTransformationObjectInRange(trsObjectRef: TransformationObjectData):
	if (!transformObjectsInRange.has(trsObjectRef)):
		transformObjectsInRange.push_back(trsObjectRef)

func UnsetTransformationObjectInRange(trsObjectRef: TransformationObjectData):
	if (transformObjectsInRange.has(trsObjectRef)):
		transformObjectsInRange.erase(trsObjectRef)

func SetNewTransformation():
	if (playerRef.playerInputs.interactInput && transformObjectsInRange.size() > 0 && !isTransformed):
		SaveNewTransformation(transformObjectsInRange[transformObjectsInRange.size() - 1])
		objectSavedSound.play()
		emit_signal("send_transformation_active_info", transformationTimer, transformationDuration)

func GenerateTransformationObject():
	if (currentTransformationObject == null || (currentOriginalObjectPath != currentTransformationObject.scene_file_path)):
		if (currentTransformationObject != null && currentOriginalObjectPath != currentTransformationObject.scene_file_path):
			var oldObjectToDelete: TransformationObjectData = currentTransformationObject
			oldObjectToDelete.queue_free()
		currentTransformationObject = InstantiateScene(currentOriginalObjectPath)
		currentTransformationObject.reparent(get_tree().root.get_child(0).sceneSelector.currentScene)
		currentTransformationObject.global_position = transformationObjectSafeCoords
		DeactivateObjectToOperate(currentTransformationObject)
		playerTransformedSprite.texture = currentTransformationObject.transformedTexture.texture
		playerTransformedSprite.scale = currentTransformationObject.transformedTextureScale
		currentAttack = SpawnTransformationSpecialObject(currentTransformationObject.transformedAttackPath, currentAttack)
		currentTransformationPassive = SpawnTransformationSpecialObject(currentTransformationObject.transformedPassivePath, currentTransformationPassive)
		if (currentTransformationPassive != null): currentTransformationPassive.SetTransformationChangeRef(self)

func SaveNewTransformation(trsObjectToSave: TransformationObjectData):
	if (trsObjectToSave.scene_file_path != currentOriginalObjectPath):
		transformationTimer = 0
	currentTransformationSet = true
	currentOriginalObjectPath = trsObjectToSave.scene_file_path
	GenerateTransformationObject()
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
		GenerateTransformationObject()
		TransformationFeedbackActivation(true)
		if (currentTransformationObject.transformedAttackPath != ""):
			emit_signal("send_transformation_has_attack", true)
		else:
			emit_signal("send_transformation_has_attack", false)
		if (!enterTransformationSound.playing): enterTransformationSound.play()
		baseCollisionShape.shape = currentTransformationObject.transformedCollider.shape
		playerSprite.hide()
		playerTransformedSprite.show()
		emit_signal("change_speed", currentTransformationObject.transformedSpeedTier)
		isTransformed = true
		ActivateLock()

func CheckForDeactivateTransformation():
	if (playerRef.playerInputs.transformInput && isTransformed && !transformationLock):
		call_deferred("DeactivateTransformation")

func DeactivateTransformation():
	TransformationFeedbackActivation(false)
	emit_signal("reset_speed")
	emit_signal("send_transformation_has_attack", true)
	if (!exitTransformationSound.playing): exitTransformationSound.play()
	if (transformationTimeLowSound.playing): transformationTimeLowSound.stop()
	if (playerRef.transformationInvincibility): playerRef.transformationInvincibility = false
	baseCollisionShape.shape = baseCollisionShapeInfo
	playerTransformedSprite.hide()
	playerSprite.show()
	isTransformed = false
	timeLowSoundPlayed = false
	clear_guards_looking_for_me()
	ActivateLock()

func TransformationActive(delta):
	if (isTransformed):
		if (transformationTimer < transformationDuration):
			transformationTimer = clamp(transformationTimer + delta, 0, transformationDuration)
			if (transformationTimer >= lowTimeRemaining && !transformationTimeLowSound.playing && !timeLowSoundPlayed):
				transformationTimeLowSound.play()
				timeLowSoundPlayed = true
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
	localAllowedItemsRef = localRef

func UnsetLocalZone():
	localAllowedItemsRef = null

func clear_guards_looking_for_me():
	for i in guardsLookingForMe.size():
		for y in guardsLookingForMe[i].stunnedGuardsList.size():
			if (guardsLookingForMe[i].stunnedGuardsList[y] == playerRef):
				guardsLookingForMe[i].stunnedGuardsList.remove_at(y)
				break
	guardsLookingForMe.clear()

func get_if_transformed_in_right_zone():
	if (isTransformed):
		if (localAllowedItemsRef != null):
			if (localAllowedItemsRef.allowedObjects.has(currentTransformationObject.transformedName)):
				return 1
		return 2
	return 0

func SpawnTransformationSpecialObject(path: String, objectVariable: Node2D):
	if (objectVariable != null):
		if (objectVariable.get_parent() != null):
			self.remove_child(objectVariable)
		if (objectVariable is ExecuteAttack):
			objectVariable.frameMaster.RemoveAttack(objectVariable)
		objectVariable.queue_free()
		objectVariable = null
	if (path != ""):
		objectVariable = InstantiateScene(path)
		objectVariable.characterRef = playerRef
	return objectVariable

func InstantiateScene(path: String):
	var scene = load(path)
	var ref = scene.instantiate()
	add_child(ref)
	return ref

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
