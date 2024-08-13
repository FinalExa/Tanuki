class_name WardenCheck
extends Area2D

@export var enemyController: EnemyController
@export var checkMaxValue: float
@export var checkMinValue: float
@export var checkIncreasePerSecond: float
@export var checkDecreasePerSecond: float
@export var enemyStatus: EnemyStatus
@export var alertGuardsArea: ScreamArea
var checkCurrentValue: float
var raycastResult: Node2D
var playerRef: PlayerCharacter
var playerIn: bool

func _ready():
	alertGuardsArea.SetMaxAreaSize()
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
	checkCurrentValue = clamp(checkCurrentValue + (delta * checkIncreasePerSecond), checkMinValue, checkMaxValue)
	UpdateLabelValue()

func DecreaseCheckValue(delta):
	checkCurrentValue = clamp(checkCurrentValue - (delta * checkDecreasePerSecond), checkMinValue, checkMaxValue)
	UpdateLabelValue()

func AddArea():
	if (alertGuardsArea.get_parent() == null):
		add_child(alertGuardsArea)

func RemoveArea():
	if (alertGuardsArea.get_parent() != null):
		alertGuardsArea.get_parent().remove_child(alertGuardsArea)

func EndWardenCheck():
	checkCurrentValue = 0
	CheckToRemoveArea()

func CheckToRemoveArea():
	RemoveArea()
	if (enemyController.enemyRotator.isLookingAtNode && enemyController.enemyRotator.target is PlayerCharacter):
		enemyController.enemyRotator.stopLooking()

func _on_warden_damaged(direction: Vector2):
	if (raycastResult is PlayerCharacter):
		EndWardenCheck()
		enemyController.enemyStunned.start_stun(direction)
