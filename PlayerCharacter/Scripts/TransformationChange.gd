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
var currentTransformationTexture: Texture2D
var currentTransformationTextureScale: Vector2
var currentTransformationAttackPath: String
var currentOriginalObjectPath: String

var currentAttack: TransformObjectAttack
var guardsLookingForMe: Array[GuardResearch]

var isTransformed: bool = false
@export var transformationDuration: float
@export var tailActivationTime: float
@export var lowTimeRemaining: float
@export var timeRefundOnReactivation: float
@export var tailRef: Node2D
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
var baseCollisionShapeInfo
var baseTextureInfo: SpriteFrames
var baseTextureScale
var tailInstance
var transformationTimer

@export var transformationLockDuration: float
var transformationLockTimer: float
var transformationLock: bool = false
var timeLowSoundPlayed: bool = false

var sceneRef: Node2D
var localAllowedItemsRef: LocalAllowedItems

func _ready():
	transformationTimer = 0
	baseCollisionShapeInfo = baseCollisionShape.shape
	baseTextureInfo = playerSprite.sprite_frames
	baseTextureScale = playerSprite.scale
	get_parent().remove_child.call_deferred(playerTransformedSprite)
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
	if (playerRef.playerInputs.interactInput && transformObjectsInRange.size() > 0):
		SaveNewTransformation(transformObjectsInRange[transformObjectsInRange.size() - 1])
		if (!objectSavedSound.playing): objectSavedSound.play()

func SaveNewTransformation(trsObjectToSave: TransformationObjectData):
	currentTransformationSet = true
	currentTransformationName = trsObjectToSave.transformedName
	currentTransformationSpeed = trsObjectToSave.transformedMaxSpeed
	currentTransformationProperties = trsObjectToSave.transformedProperties
	currentTransformationCollisionShape = trsObjectToSave.transformedCollider
	currentTransformationTexture = trsObjectToSave.transformedTexture.texture
	currentTransformationTextureScale = trsObjectToSave.transformedTextureScale
	currentTransformationAttackPath = trsObjectToSave.transformedAttackPath
	currentOriginalObjectPath = trsObjectToSave.scene_file_path
	AddTransformationAttack()
	emit_signal("send_transformation_name", currentTransformationName)

func ActivateTransformation():
	if (playerRef.playerInputs.transformInput && currentTransformationSet && !isTransformed && !transformationLock):
		if (!enterTransformationSound.playing): enterTransformationSound.play()
		transformationTimer=clamp(transformationTimer-timeRefundOnReactivation,0,transformationDuration)
		baseCollisionShape.shape = currentTransformationCollisionShape.shape
		get_parent().add_child(playerTransformedSprite)
		playerTransformedSprite.texture = currentTransformationTexture
		playerTransformedSprite.scale = currentTransformationTextureScale
		emit_signal("change_speed", currentTransformationSpeed)
		isTransformed = true
		ActivateLock()

func CheckForDeactivateTransformation():
	if (playerRef.playerInputs.transformInput && isTransformed && !transformationLock):
		DeactivateTransformation()

func DeactivateTransformation():
	emit_signal("reset_speed")
	if (!exitTransformationSound.playing): exitTransformationSound.play()
	if (transformationTimeLowSound.playing) : transformationTimeLowSound.stop()
	baseCollisionShape.shape = baseCollisionShapeInfo
	get_parent().remove_child(playerTransformedSprite)
	playerSprite.sprite_frames = baseTextureInfo
	playerSprite.scale = baseTextureScale
	isTransformed = false
	timeLowSoundPlayed = false
	if (tailInstance != null):
		sceneRef.remove_child(tailInstance)
		tailInstance = null
	clear_guards_looking_for_me()
	ActivateLock()

func TransformationActive(delta):
	if (isTransformed):
		if (transformationTimer < transformationDuration):
			transformationTimer = clamp(transformationTimer + delta, 0, transformationDuration)
			if(transformationTimer >= tailActivationTime && tailInstance == null):
				AddTail()
			if (transformationTimer >= lowTimeRemaining && !transformationTimeLowSound.playing && !timeLowSoundPlayed):
				transformationTimeLowSound.play()
				timeLowSoundPlayed = true
		else:
			DeactivateTransformation()
	else:
		if (transformationTimer > 0):
			transformationTimer=clamp(transformationTimer-delta,0,transformationDuration)
	emit_signal("send_transformation_active_info", isTransformed, transformationTimer, transformationDuration)

func AddTail():
	sceneRef.add_child(tailRef)
	for i in sceneRef.get_child_count():
		if (sceneRef.get_child(i) == tailRef):
			tailInstance = sceneRef.get_child(i)
			tailInstance.playerRef = playerRef
			tailInstance.objectToTrack = tailLocation
			break
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

func AddTransformationAttack():
	var children = get_children()
	for i in children.size():
		if (children[i] is TransformObjectAttack):
			remove_child(children[i])
			i -= 1
	if (currentTransformationAttackPath != ""):
		var new_atk_scene = load(currentTransformationAttackPath)
		var new_atk = new_atk_scene.instantiate()
		add_child(new_atk)
		currentAttack = new_atk
		currentAttack.characterRef = playerRef
	else:
		currentAttack = null

func CheckForAttackInput():
	if (currentAttack != null && !currentAttack.attackLaunched && Input.is_action_just_pressed("attack") && isTransformed):
		currentAttack.start_attack()
