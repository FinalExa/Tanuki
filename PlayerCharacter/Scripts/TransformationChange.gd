class_name TransformationChange
extends Node2D

signal change_speed
signal reset_speed
signal send_transformation_name
signal send_transformation_active_info

var isInsidePossibleTransformationObject: bool
var tempTransformationName: String
var tempTransformationSpeed: float
var tempTransformationProperties: Array[String]
var tempTransformationCollisionShape: CollisionShape2D
var tempTransformationTexture: Texture2D
var tempTransformationTextureScale: Vector2
var tempTransformAttackPath: String
var tempOriginalObjectPath: String

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
@export var transformationDuration = 0
@export var tailActivationTime = 0
@export var timeRefundOnReactivation = 0
@export var tailRef: Node2D
@export var tailLocation: Node2D
@export var playerRef: PlayerCharacter
@export var baseCollisionShape: CollisionShape2D
@export var playerSprite: AnimatedSprite2D
@export var enterTransformationSound: AudioStreamPlayer
@export var exitTransformationSound: AudioStreamPlayer
@export var playerTransformedSprite: Sprite2D
var baseCollisionShapeInfo
var baseTextureInfo: SpriteFrames
var baseTextureScale
var tailInstance
var transformationTimer

@export var transformationLockDuration = 0
var transformationLockTimer
var transformationLock = false

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
	set_new_transformation()
	activate_transformation()
	manual_deactivate_transformation()
	transformation_active(delta)
	transformation_lock(delta)
	check_for_attack_input()

func set_temp_trs(tempName, tempSpeed, tempProperties, tempCollider, tempTexture, tempTextureScale, tempAttackPath, tempOriginalPath):
	isInsidePossibleTransformationObject = true
	tempTransformationName = tempName
	tempTransformationSpeed = tempSpeed
	tempTransformationProperties = tempProperties
	tempTransformationCollisionShape = tempCollider
	tempTransformationTexture = tempTexture
	tempTransformationTextureScale = tempTextureScale
	tempTransformAttackPath = tempAttackPath
	tempOriginalObjectPath = tempOriginalPath

func unset_temp_trs():
	isInsidePossibleTransformationObject = false

func set_new_transformation():
	if (Input.is_action_just_pressed("interact") && isInsidePossibleTransformationObject):
		actually_set_new_transformation()

func actually_set_new_transformation():
	currentTransformationSet = true
	currentTransformationName = tempTransformationName
	currentTransformationSpeed = tempTransformationSpeed
	currentTransformationProperties = tempTransformationProperties
	currentTransformationCollisionShape = tempTransformationCollisionShape
	currentTransformationTexture = tempTransformationTexture
	currentTransformationTextureScale = tempTransformationTextureScale
	currentTransformationAttackPath = tempTransformAttackPath
	currentOriginalObjectPath = tempOriginalObjectPath
	add_attack()
	emit_signal("send_transformation_name", currentTransformationName)

func activate_transformation():
	if (Input.is_action_just_pressed("transformation") && currentTransformationSet && !isTransformed && !transformationLock):
		if (!enterTransformationSound.playing): enterTransformationSound.play()
		transformationTimer=clamp(transformationTimer-timeRefundOnReactivation,0,transformationDuration)
		baseCollisionShape.shape = currentTransformationCollisionShape.shape
		get_parent().add_child(playerTransformedSprite)
		playerTransformedSprite.texture = currentTransformationTexture
		playerTransformedSprite.scale = currentTransformationTextureScale
		emit_signal("change_speed", currentTransformationSpeed)
		isTransformed = true
		transformation_lock_activate()

func manual_deactivate_transformation():
	if (Input.is_action_just_pressed("transformation") && isTransformed && !transformationLock):
		deactivate_transformation()

func deactivate_transformation():
	emit_signal("reset_speed")
	if (!exitTransformationSound.playing): exitTransformationSound.play()
	baseCollisionShape.shape = baseCollisionShapeInfo
	get_parent().remove_child(playerTransformedSprite)
	playerSprite.sprite_frames = baseTextureInfo
	playerSprite.scale = baseTextureScale
	isTransformed = false
	if (tailInstance != null):
		sceneRef.remove_child(tailInstance)
		tailInstance = null
	clear_guards_looking_for_me()
	transformation_lock_activate()

func transformation_active(delta):
	if (isTransformed):
		if (transformationTimer<transformationDuration):
			transformationTimer=clamp(transformationTimer+delta,0,transformationDuration)
			if(transformationTimer>=tailActivationTime && tailInstance == null):
				sceneRef.add_child(tailRef)
				for i in sceneRef.get_child_count():
					if (sceneRef.get_child(i) == tailRef):
						tailInstance = sceneRef.get_child(i)
						tailInstance.playerRef = playerRef
						tailInstance.objectToTrack = tailLocation
						break
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

func set_local_zone(localRef: LocalAllowedItems):
	localAllowedItemsRef = localRef

func unset_local_zone():
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

func add_attack():
	var children = get_children()
	for i in children.size():
		if (children[i] is TransformObjectAttack):
			remove_child(children[i])
			i-=1
	if (currentTransformationAttackPath != ""):
		var new_atk_scene = load(currentTransformationAttackPath)
		var new_atk = new_atk_scene.instantiate()
		add_child(new_atk)
		children = get_children()
		for i in children.size():
			if (children[i] is TransformObjectAttack):
				currentAttack = children[i]
				break
		currentAttack.characterRef = playerRef
	else:
		currentAttack = null

func check_for_attack_input():
	if (currentAttack != null && !currentAttack.attackLaunched && Input.is_action_just_pressed("attack") && isTransformed):
		currentAttack.start_attack()
