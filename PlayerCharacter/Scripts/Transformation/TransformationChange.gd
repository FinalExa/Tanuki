class_name TransformationChange
extends Node2D

signal change_speed
signal reset_speed
signal send_transformation_texture
signal send_transformation_has_attack
signal send_transformation_active_info

@export var playerRef: PlayerCharacter
@export var transformationSaving: TransformationSaving
@export var transformationActivation: TransformationActivation
@export var transformationAttacking: TransformationAttacking
@export var transformationSprite: TransformationSprite
@export var transformationOriginalObject: TransformationOriginalObject
@export var transformationSounds: TransformationSounds
@export var trasformationUndetectable: TrasformationUndetectable
@export var transformationLock: TransformationLock
@export var transformationBaseDuration: float
@export var transformationExtraDuration: float
@export var baseCollisionShape: CollisionShape2D
@export var playerSprite: AnimatedSprite2D
@export var noTransformationText: String
@export var transformationObjectSafeCoords: Vector2
@export var transformationAttackTimerCost: float

var transformationDuration: float = 0
var currentTransformationObject: TransformationObjectData
var currentOriginalObjectPath: String
var currentTransformationSet: bool
var currentTransformationPassive: TransformationObjectPassive
var currentAttack: ExecuteAttack
var isTransformed: bool
var undetectable: bool
var superUndetectable: bool
var transformationTimer: float
var baseCollisionShapeInfo: Shape2D
var transformationLocked: bool
var sceneRef: Node2D
var localAllowedItemsRef: Array[LocalAllowedItems]
var upgradeDuration: bool

func _ready():
	InitialSetup()

func InitialSetup():
	if (transformationDuration == 0):
		ResetUpgradeDuration()
	baseCollisionShapeInfo = baseCollisionShape.shape
	transformationSprite.Startup()
	emit_signal("send_transformation_active_info", transformationTimer, transformationDuration, noTransformationText)
	emit_signal("send_transformation_has_attack", true, "Leaf")

func _process(delta):
	transformationSaving.TransformationSavedSpriteUpdate()
	transformationSprite.FlipTransformationSprite()
	transformationLock.LockTimer(delta)
	trasformationUndetectable.UndetectableTimer(delta)
	transformationSaving.SetNewTransformation()
	transformationActivation.ActivateTransformation()
	transformationActivation.CheckForDeactivateTransformation()
	transformationActivation.TransformationActive(delta)
	transformationAttacking.CheckForAttackInput()

func ResetUpgradeDuration():
	upgradeDuration = false
	transformationDuration = transformationBaseDuration
	transformationSounds.lowTimeRemaining = transformationSounds.baseLowTime

func EnableUpgradeDuration():
	upgradeDuration = true
	transformationDuration = transformationBaseDuration + transformationExtraDuration
	transformationSounds.lowTimeRemaining = transformationSounds.baseLowTime + transformationExtraDuration

func SetNoTransformation():
	if (currentTransformationObject != null): transformationActivation.call_deferred("DeactivateTransformation")
	transformationSaving.SetNoTransformation()

func SetNoTransformationExternal():
	transformationSounds.PlayTransformationRemovedSound()
	SetNoTransformation()

func SetLocalZone(localRef: LocalAllowedItems):
	if (!localAllowedItemsRef.has(localRef)):
		localAllowedItemsRef.push_back(localRef)

func UnsetLocalZone(localRef: LocalAllowedItems):
	if (localAllowedItemsRef.has(localRef)):
		localAllowedItemsRef.erase(localRef)

func get_if_transformed_in_right_zone():
	if (undetectable || superUndetectable): return 1
	if (isTransformed):
		if (localAllowedItemsRef != null):
			for i in localAllowedItemsRef.size():
				if (localAllowedItemsRef[i].allowedObjects.has(currentTransformationObject.transformedName)):
					return 1
		return 2
	return 0

func _on_player_character_transformation_invincibility_interacted(receivedNode: Node2D):
	transformationOriginalObject.InvincibilityInteracted(receivedNode)

func DeactivateObjectToOperate(objectToOperate: Node2D):
	if (objectToOperate is PuzzleObject):
		objectToOperate.Deactivation()
		return
	objectToOperate.hide()
	for i in objectToOperate.get_child_count():
		if (objectToOperate.get_child(i) is CollisionShape2D || objectToOperate.get_child(i) is CollisionPolygon2D):
			objectToOperate.get_child(i).disabled = true
