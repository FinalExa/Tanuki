class_name TransformationChange
extends Node2D

signal change_speed
signal reset_speed
signal send_transformation_name
signal send_transformation_active_info

var transformObjectsInRange: Array[TransformationObjectData]

var currentTransformationSet: bool
var currentTransformationName: String
var currentTransformationSpeed: float
var currentTransformationProperties: Array[String]
var currentTransformationCollisionShape: CollisionShape2D
var currentTransformationPassive: TransformationObjectPassive
var currentOriginalObjectPath: String

var currentAttack: ExecuteAttack
var guardsLookingForMe: Array[GuardResearch]

var isTransformed: bool = false
@export var transformationDuration: float
@export var tailActivationTime: float
@export var lowTimeRemaining: float
@export var tailRef: TailFollow
@export var tailLocation: Node2D
@export var playerRef: PlayerCharacter
@export var baseCollisionShape: CollisionShape2D
@export var playerSprite: AnimatedSprite2D
@export var enterTransformationSound: AudioStreamPlayer
@export var exitTransformationSound: AudioStreamPlayer
@export var playerTransformedSprite: Sprite2D
@export var objectSavedSound: AudioStreamPlayer
@export var transformationTimeLowSound: AudioStreamPlayer
@export var tailAppearsSound: AudioStreamPlayer
@export var noTransformationText: String
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
	transformationTimer = 0
	baseCollisionShapeInfo = baseCollisionShape.shape
	baseTextureInfo = playerSprite.sprite_frames
	baseTextureScale = playerSprite.scale
	playerTransformedSprite.hide()
	self.remove_child(tailRef)

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
		if (!objectSavedSound.playing): objectSavedSound.play()

func SaveNewTransformation(trsObjectToSave: TransformationObjectData):
	transformationTimer = 0
	currentTransformationSet = true
	currentTransformationName = trsObjectToSave.transformedName
	currentTransformationSpeed = trsObjectToSave.transformedMaxSpeed
	currentTransformationProperties = trsObjectToSave.transformedProperties
	currentTransformationCollisionShape = trsObjectToSave.transformedCollider
	playerTransformedSprite.texture = trsObjectToSave.transformedTexture.texture
	playerTransformedSprite.scale = trsObjectToSave.transformedTextureScale
	currentAttack = SpawnTransformationSpecialObject(trsObjectToSave.transformedAttackPath, currentAttack)
	currentTransformationPassive = SpawnTransformationSpecialObject(trsObjectToSave.transformedPassivePath, currentTransformationPassive)
	if (currentTransformationPassive != null): currentTransformationPassive.SetTransformationChangeRef(self)
	currentOriginalObjectPath = trsObjectToSave.scene_file_path
	tailLocation.position = trsObjectToSave.transformedTailLocation.position
	emit_signal("send_transformation_name", currentTransformationName)

func SetNoTransformation():
	currentTransformationSet = false
	emit_signal("send_transformation_name", noTransformationText)

func ActivateTransformation():
	if (playerRef.playerInputs.transformInput && currentTransformationSet && !isTransformed && !transformationLock):
		if (!enterTransformationSound.playing): enterTransformationSound.play()
		baseCollisionShape.shape = currentTransformationCollisionShape.shape
		playerSprite.hide()
		playerTransformedSprite.show()
		emit_signal("change_speed", currentTransformationSpeed)
		isTransformed = true
		ActivateLock()

func CheckForDeactivateTransformation():
	if (playerRef.playerInputs.transformInput && isTransformed && !transformationLock):
		DeactivateTransformation()

func DeactivateTransformation():
	emit_signal("reset_speed")
	if (!exitTransformationSound.playing): exitTransformationSound.play()
	if (transformationTimeLowSound.playing): transformationTimeLowSound.stop()
	if (playerRef.transformationInvincibility): playerRef.transformationInvincibility = false
	baseCollisionShape.shape = baseCollisionShapeInfo
	playerTransformedSprite.hide()
	playerSprite.show()
	isTransformed = false
	timeLowSoundPlayed = false
	if (tailRef.get_parent() != null):
		sceneRef.remove_child(tailRef)
	clear_guards_looking_for_me()
	ActivateLock()

func TransformationActive(delta):
	if (isTransformed):
		if (transformationTimer < transformationDuration):
			transformationTimer = clamp(transformationTimer + delta, 0, transformationDuration)
			if(transformationTimer >= tailActivationTime && tailRef.get_parent() == null):
				AddTail()
			if (transformationTimer >= lowTimeRemaining && !transformationTimeLowSound.playing && !timeLowSoundPlayed):
				transformationTimeLowSound.play()
				timeLowSoundPlayed = true
		else:
			DeactivateTransformation()
			SetNoTransformation()
	emit_signal("send_transformation_active_info", transformationTimer, transformationDuration)

func AddTail():
	sceneRef.add_child(tailRef)
	tailRef.playerRef = playerRef
	tailRef.objectToTrack = tailLocation
	if (!tailAppearsSound.playing): tailAppearsSound.play()

func ActivateLock():
	transformationLock = true
	transformationLockTimer = 0

func LockTimer(delta):
	if (transformationLock):
		if (transformationLockTimer<transformationLockDuration):
			transformationLockTimer+=delta
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
			if (localAllowedItemsRef.allowedObjects.has(currentTransformationName)):
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

func _on_player_character_transformation_invincibility_interacted(receivedNode: Node2D):
	if (currentTransformationPassive != null):
		currentTransformationPassive.TransformationInvincibilityInteracted(receivedNode)
