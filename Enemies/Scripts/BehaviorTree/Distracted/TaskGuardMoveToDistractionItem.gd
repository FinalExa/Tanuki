extends GuardNode

@export var guardDistraction: GuardDistraction
@export var enemyMovement: EnemyMovement
@export var enemyRotator: EnemyRotator

func Evaluate(_delta):
	if (enemyMovement.target != guardDistraction.closestSource && enemyController.global_position.distance_to(guardDistraction.closestSource.global_position) > guardDistraction.distractedObjDistance):
		enemyMovement.reset_movement_speed()
		enemyMovement.set_new_target(guardDistraction.closestSource)
		enemyRotator.setLookingAtNode(guardDistraction.closestSource)
	if (enemyMovement.target == guardDistraction.closestSource && enemyController.global_position.distance_to(guardDistraction.closestSource.global_position) <= guardDistraction.distractedObjDistance):
		enemyMovement.set_new_target(null)
	return NodeState.FAILURE
