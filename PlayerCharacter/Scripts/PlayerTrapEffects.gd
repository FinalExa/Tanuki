class_name PlayerTrapEffects
extends Node

@export var playerRef: PlayerCharacter
var currentTraps: Array[TrapObject]

func _process(delta):
	Execution(delta)

func RegisterEffect(trap: TrapObject):
	if (!currentTraps.has(trap)):
		currentTraps.push_back(trap)

func UnregisterEffect(trap: TrapObject):
	if (currentTraps.has(trap)):
		currentTraps.erase(trap)
		trap.effect.OnLeaveEffect(playerRef)
		trap.effect.launchedOnEnter = false

func Execution(delta):
	if (currentTraps.size() > 0):
		var nullIdArray: Array[int] = []
		for i in currentTraps.size():
			if (currentTraps[i] != null):
				PlayerEffects(currentTraps[i], delta)
			else:
				nullIdArray.push_front(i)
		if (nullIdArray.size() > 0):
			for i in nullIdArray.size():
				currentTraps.remove_at(nullIdArray[i])

func PlayerEffects(trap: TrapObject, delta):
	if (PlayerHasRightTag(trap)):
		trap.effect.NegatedEffect(playerRef, delta)
		return
	if (!trap.effect.launchedOnEnter):
		trap.effect.OnEnterEffect(playerRef)
		trap.effect.launchedOnEnter = true
	trap.effect.NormalEffect(playerRef, delta)

func PlayerHasRightTag(trap: TrapObject):
	return (playerRef.transformationChangeRef.isTransformed && playerRef.transformationChangeRef.currentTransformationObject.transformedProperties.has(trap.effectNegateProperty))
