extends GuardNode

@export var guardResearch: GuardResearch

func _ready():
	state = NodeState.FAILURE

func Evaluate(_delta):
	return state

func _physics_process(_delta):
	research_secondary_raycast()
	state = NodeState.SUCCESS

func research_secondary_raycast():
	if (guardController.isInResearch):
		var checkForPlayer: bool = false
		var spaceState = guardController.get_world_2d().direct_space_state
		for i in guardResearch.secondaryRayTargets.size():
			var query = PhysicsRayQueryParameters2D.create(guardController.global_position, guardResearch.secondaryRayTargets[i].global_position)
			var result = spaceState.intersect_ray(query)
			if (result && result != { }):
				checkForPlayer = spot_player_from_afar(result.collider)
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
