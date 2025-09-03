class_name WardenCheck
extends Area2D

@export var wardenController: WardenController
@export var checkMaxValue: float
@export var checkMinValue: float
@export var checkScreamThreshold: float
@export var checkIncreasePerSecond: float
@export var checkDecreasePerSecond: float
@export var enemyStatus: EnemyStatus
@export var checkSound: AudioStreamPlayer2D
@export var spottedSound: AudioStreamPlayer2D
@export var wardenSprite: AnimatedSprite2D
@export var idleAnimationName: String
@export var spottedAnimationName: String
var activated: bool
var isInIdleAnimation: bool
var wardenAlertArea: WardenAlertArea
var checkCurrentValue: float
var raycastResult: Node2D
var playerRef: PlayerCharacter
var checkSoundPlayed: bool
var spottedSoundPlayed: bool

func _ready():
	Activate()
	checkCurrentValue = 0

func _physics_process(_delta):
	WardenCheckRaycast()

func _process(_delta):
	PlayAnimations()

func WardenCheckRaycast():
	if (playerRef != null && activated):
		var space_state = wardenController.get_world_2d().direct_space_state
		raycastResult = null
		var query = PhysicsRayQueryParameters2D.create(wardenController.global_position, playerRef.global_position)
		query.exclude = [wardenController, wardenController.wardenCollider]
		var result = space_state.intersect_ray(query)
		if (result && result != { }):
			raycastResult = result.collider
		else:
			raycastResult = null
		return
	raycastResult = null

func UpdateLabelValue():
	enemyStatus.updateValue(checkCurrentValue, checkMaxValue)

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerRef = null

func IncreaseCheckValue(delta):
	PlayCheckSound()
	checkCurrentValue = clamp(checkCurrentValue + (delta * checkIncreasePerSecond), checkMinValue, checkMaxValue)
	PlaySpottedSound()
	UpdateLabelValue()

func DecreaseCheckValue(delta):
	ResetSpottedSound()
	checkCurrentValue = clamp(checkCurrentValue - (delta * checkDecreasePerSecond), checkMinValue, checkMaxValue)
	ResetCheckSound()
	UpdateLabelValue()

func AddArea():
	wardenAlertArea.SetActive()

func RemoveArea():
	wardenAlertArea.SetInactive()

func EndWardenCheck():
	checkCurrentValue = 0
	CheckToRemoveArea()

func CheckToRemoveArea():
	RemoveArea()
	if (wardenController.enemyRotator.isLookingAtNode && wardenController.enemyRotator.target is PlayerCharacter):
		wardenController.enemyRotator.stopLooking()

func _on_warden_damaged(direction: Vector2, tier: EnemyStunned.StunTier):
	if (raycastResult is PlayerCharacter):
		EndWardenCheck()
		wardenController.enemyStunned.start_stun(direction, tier)

func PlayCheckSound():
	if (checkCurrentValue == checkMinValue && !checkSoundPlayed):
		checkSound.play()
		checkSoundPlayed = true

func PlayAnimations():
	if (checkCurrentValue >= checkScreamThreshold):
		if (isInIdleAnimation):
			wardenSprite.play(spottedAnimationName)
			isInIdleAnimation = false
	else:
		if (!isInIdleAnimation):
			wardenSprite.play(idleAnimationName)
			isInIdleAnimation = true

func ResetCheckSound():
	if (checkCurrentValue == checkMinValue && checkSoundPlayed):
		checkSoundPlayed = false

func PlaySpottedSound():
	if (checkCurrentValue >= checkScreamThreshold && !spottedSoundPlayed):
		spottedSound.play()
		spottedSoundPlayed = true

func ResetSpottedSound():
	if (checkCurrentValue == checkMaxValue && spottedSoundPlayed):
		spottedSoundPlayed = false

func Activate():
	self.show()
	activated = true

func Deactivate():
	self.hide()
	activated = false
