extends GuardNode

@export var guardResearch: GuardResearch

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	ResearchSecondaryRaycast()
	return NodeState.SUCCESS

func ResearchSecondaryRaycast():
	for i in guardResearch.secondaryRaycastResult.size():
		if (guardResearch.secondaryRaycastResult[i] != null):
			if (SpotPlayerFromAfar(guardResearch.secondaryRaycastResult[i])):
				guardResearch.researchHasFoundSomething = true
				return
	guardResearch.researchHasFoundSomething = false

func SpotPlayerFromAfar(target):
	if (target is PlayerCharacter):
		var playerTrsState = target.transformationChangeRef.get_if_transformed_in_right_zone()
		if (playerTrsState != 1):
			if (playerTrsState == 0):
				guardResearch.save_target_info(target, true)
			else:
				guardResearch.save_target_info(target, false)
			return true
	return false
