class_name TrapObject
extends Area2D

@export var effectNegateProperty: String
@export var effect: TrapObjectEffect
@export var worksOnEnemies: Array[String]
@export var useAlternativeStart: bool
var objectsInArea: Array[Node2D]
var activated: bool
var enabled: bool

func _ready():
	activated = true
	enabled = true
	if (useAlternativeStart):
		effect.AlternativeStartup()
		return
	effect.Startup()

func _physics_process(delta):
	if (enabled && activated):
		ExecuteEffects(delta)

func ExecuteEffects(delta):
	if (objectsInArea.size() > 0):
		for i in objectsInArea.size():
			if (objectsInArea[i] is EnemyController && worksOnEnemies.size() > 0 && worksOnEnemies.has(objectsInArea[i].enemyName)):
				EnemyEffects(objectsInArea[i], delta)

func EnemyEffects(enemyRef: EnemyController, delta):
	if (enemyRef.enemyProperties.has(effectNegateProperty)):
		effect.NegatedEffect(enemyRef, delta)
		return
	effect.NormalEffect(enemyRef, delta)

func TurnOff():
	enabled = false

func TurnOn():
	enabled = true

func _on_body_entered(body):
	if (body is PlayerCharacter || body is EnemyController):
		if (!objectsInArea.has(body)):
			objectsInArea.push_back(body)
			if (body is PlayerCharacter):
				RegisterToPlayer(body)

func _on_body_exited(body):
	if (body is PlayerCharacter || body is EnemyController):
		if (objectsInArea.has(body)):
			if (body is PlayerCharacter):
				UnregisterFromPlayer(body)
			else:
				effect.OnLeaveEffect(body)
			objectsInArea.erase(body)

func RegisterToPlayer(playerRef: PlayerCharacter):
	playerRef.playerTrapEffects.RegisterEffect(self)

func UnregisterFromPlayer(playerRef: PlayerCharacter):
	playerRef.playerTrapEffects.UnregisterEffect(self)
