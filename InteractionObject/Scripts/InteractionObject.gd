class_name InteractionObject
extends Area2D

@export var effectNegateProperty: String
@export var effect: InteractionObjectEffect
var objectsInArea: Array[Node2D]

func _ready():
	self.add_child(effect)

func _on_body_entered(body):
	if (body is PlayerCharacter || body is GuardController):
		if(!objectsInArea.has(body)):
			objectsInArea.push_back(body)

func _on_body_exited(body):
	if (body is PlayerCharacter || body is GuardController):
		if(objectsInArea.has(body)):
			objectsInArea.erase(body)

func _physics_process(delta):
	execute_effects()

func execute_effects():
	if (objectsInArea.size()>0):
		for i in objectsInArea.size():
			if (objectsInArea[i] is PlayerCharacter):
				execute_effect_on_player(objectsInArea[i])
			else:
				execute_effect_on_guard(objectsInArea[i])

func execute_effect_on_player(playerRef: PlayerCharacter):
	if (playerRef.transformationChangeRef.isTransformed && playerRef.transformationChangeRef.currentTransformationProperties.has(effectNegateProperty)):
		effect.execute_negated_effect(playerRef)
		return
	effect.execute_effect_normally(playerRef)

func execute_effect_on_guard(guardRef: GuardController):
	if (guardRef.guardProperties.has(effectNegateProperty)):
		effect.execute_negated_effect(guardRef)
		return
	effect.execute_effect_normally(guardRef)
