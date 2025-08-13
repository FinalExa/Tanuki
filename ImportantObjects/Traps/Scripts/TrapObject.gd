class_name TrapObject
extends Area2D

@export var effectNegateProperty: String
@export var effect: TrapObjectEffect
var objectsInArea: Array[Node2D]
var activated: bool
var enabled: bool

func _ready():
	activated = true
	enabled = true

func _physics_process(delta):
	if (enabled && activated):
		ExecuteEffects(delta)

func ExecuteEffects(delta):
	if (objectsInArea.size()>0):
		for i in objectsInArea.size():
			if (objectsInArea[i] is PlayerCharacter):
				PlayerEffects(objectsInArea[i], delta)
			else:
				EnemyEffects(objectsInArea[i], delta)

func PlayerEffects(playerRef: PlayerCharacter, delta):
	if (playerRef.transformationChangeRef.isTransformed && playerRef.transformationChangeRef.currentTransformationObject.transformedProperties.has(effectNegateProperty)):
		effect.NegatedEffect(playerRef, delta)
		return
	effect.NormalEffect(playerRef, delta)

func EnemyEffects(guardRef: GuardController, delta):
	if (guardRef.enemyProperties.has(effectNegateProperty)):
		effect.NegatedEffect(guardRef, delta)
		return
	effect.NormalEffect(guardRef, delta)

func TurnOff():
	enabled = false

func TurnOn():
	enabled = true

func _on_body_entered(body):
	if (body is PlayerCharacter || body is EnemyController):
		if(!objectsInArea.has(body)):
			objectsInArea.push_back(body)

func _on_body_exited(body):
	if (body is PlayerCharacter || body is EnemyController):
		if(objectsInArea.has(body)):
			effect.OnLeaveEffect(body)
			objectsInArea.erase(body)
