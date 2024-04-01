extends GuardNode

@export var guardResearch: GuardResearch

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	research_secondary_raycast()
	return NodeState.SUCCESS

func research_secondary_raycast():
	var checkForPlayer: bool = false
	for i in guardResearch.secondaryRaycastResult.size():
		if (guardResearch.secondaryRaycastResult[i] != null):
			checkForPlayer = spot_player_from_afar(guardResearch.secondaryRaycastResult[i])
			if (checkForPlayer):
				guardResearch.researchHasFoundSomething = true
				break
	if (!checkForPlayer):
		guardResearch.researchHasFoundSomething = false

func spot_player_from_afar(target):
	if (target is PlayerCharacter):
		if (target.transformationChangeRef.get_if_transformed_in_right_zone() != 1):
			guardResearch.save_target_info(target)
		return true
	return false