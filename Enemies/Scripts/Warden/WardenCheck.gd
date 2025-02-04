class_name WardenCheck
extends Area2D

@export var enemyController: EnemyController
@export var checkMaxValue: float
@export var checkMinValue: float
@export var checkIncreasePerSecond: float
@export var checkDecreasePerSecond: float
@export var enemyStatus: EnemyStatus
@export var wardenAlertArea: WardenAlertArea
@export var checkSound: AudioStreamPlayer2D
@export var spottedSound: AudioStreamPlayer2D
var checkCurrentValue: float
var raycastResult: Node2D
var playerRef: PlayerCharacter
var playerIn: bool
var checkSoundPlayed: bool
var spottedSoundPlayed: bool

func _ready():
	RemoveArea()
	checkCurrentValue = 0

func _physics_process(_delta):
	WardenCheckRaycast()

func WardenCheckRaycast():
	if (playerIn):
		var space_state = enemyController.get_world_2d().direct_space_state
		raycastResult = null
		var query = PhysicsRayQueryParameters2D.create(enemyController.global_position, playerRef.global_position)
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
		playerIn = true
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerIn = false
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
	if (enemyController.enemyRotator.isLookingAtNode && enemyController.enemyRotator.target is PlayerCharacter):
		enemyController.enemyRotator.stopLooking()

func _on_warden_damaged(direction: Vector2, tier: EnemyStunned.StunTier):
	if (raycastResult is PlayerCharacter):
		EndWardenCheck()
		enemyController.enemyStunned.start_stun(direction, tier)

func PlayCheckSound():
	if (checkCurrentValue == checkMinValue && !checkSoundPlayed):
		checkSound.play()
		checkSoundPlayed = true

func ResetCheckSound():
	if (checkCurrentValue == checkMinValue && checkSoundPlayed):
		checkSoundPlayed = false

func PlaySpottedSound():
	if (checkCurrentValue == checkMaxValue && !spottedSoundPlayed):
		spottedSound.play()
		spottedSoundPlayed = true

func ResetSpottedSound():
	if (checkCurrentValue == checkMaxValue && spottedSoundPlayed):
		spottedSoundPlayed = false
