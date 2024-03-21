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
		var spaceState = guardController.get_world_2d().direct_space_state
		for i in guardResearch.secondaryRayTargets.size():
			var query = PhysicsRayQueryParameters2D.create(guardController.global_position, guardResearch.secondaryRayTargets[i].global_position)
			var result = spaceState.intersect_ray(query)
			if (result && result != { }):
				guardResearch.researchHasFoundSomething = spot_player_from_afar(result.collider)

func spot_player_from_afar(target):
	if (target is PlayerCharacter):
		var playerRef: PlayerCharacter = target
		if (!playerRef.transformationChangeRef.isTransformed):
			guardResearch.save_target_info(target)
	return false
