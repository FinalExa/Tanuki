class_name InteractionObject
extends Area2D

@export var effectNegateProperty: String
@export var effect: InteractionObjectEffect
@export var savedOnDestroy: bool
@export var objectToSendDestoySignal: Node2D
var sceneMaster: SceneMaster
var objectsInArea: Array[Node2D]

func _ready():
	sceneMaster = get_tree().root.get_child(0)

func _on_body_entered(body):
	if (body is PlayerCharacter || body is GuardController):
		if(!objectsInArea.has(body)):
			objectsInArea.push_back(body)

func _on_body_exited(body):
	if (body is PlayerCharacter || body is GuardController):
		if(objectsInArea.has(body)):
			effect.execute_leave_effect(body)
			objectsInArea.erase(body)

func _physics_process(delta):
	execute_effects(delta)

func execute_effects(delta):
	if (objectsInArea.size()>0):
		for i in objectsInArea.size():
			if (objectsInArea[i] is PlayerCharacter):
				execute_effect_on_player(objectsInArea[i], delta)
			else:
				execute_effect_on_guard(objectsInArea[i], delta)

func execute_effect_on_player(playerRef: PlayerCharacter, delta):
	if (playerRef.transformationChangeRef.isTransformed && playerRef.transformationChangeRef.currentTransformationProperties.has(effectNegateProperty)):
		effect.execute_negated_effect(playerRef, delta)
		return
	effect.execute_effect_normally(playerRef, delta)

func execute_effect_on_guard(guardRef: GuardController, delta):
	if (guardRef.guardProperties.has(effectNegateProperty)):
		effect.execute_negated_effect(guardRef, delta)
		return
	effect.execute_effect_normally(guardRef, delta)

func SaveOnDestroy():
	if (savedOnDestroy):
		var savedPath: String
		sceneMaster.AddPathString(self)

func SaveDestroySignalToOtherObject():
	if (objectToSendDestoySignal != null):
		objectToSendDestoySignal.DestroyedSignal()

func ExecuteLoadOperation():
	pass
