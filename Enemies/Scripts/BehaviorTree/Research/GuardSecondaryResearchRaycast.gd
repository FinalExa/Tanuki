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
	guardResearch.secondarySpotted = false
	if (guardResearch.suspiciousItemsList.has(get_tree().root.get_child(0).playerRef)):
		guardResearch.suspiciousItemsList.erase(get_tree().root.get_child(0).playerRef)
	guardResearch.researchHasFoundSomething = false

func SpotPlayerFromAfar(target):
	if (target is PlayerCharacter):
		var playerTrsState = target.transformationChangeRef.get_if_transformed_in_right_zone()
		if (playerTrsState != 1 || target.velocity != Vector2.ZERO || guardResearch.secondarySpotted):
			if (!guardResearch.secondarySpotted): guardResearch.secondarySpotted = true
			if (playerTrsState == 0):
				guardResearch.save_target_info(target, true)
			else:
				guardResearch.save_target_info(target, false)
				if (!guardResearch.suspiciousItemsList.has(target)):
					guardResearch.suspiciousItemsList.push_front(target)
			return true
		else:
			if (!guardResearch.secondarySpotted):
				enemyController.enemyMovement.set_new_target(null)
				enemyController.enemyRotator.setLookingAtNode(null)
	return false
