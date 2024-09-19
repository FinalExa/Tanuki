extends GuardNode

@export var guardAlert: GuardAlert
var guardController: GuardController

func _ready():
	guardController = enemyController

func Evaluate(delta):
	if (guardAlert.catchPreparationActive):
		if(guardAlert.catchPreparationTimer > 0):
			guardAlert.catchPreparationTimer -= delta
		else:
			guardAlert.SetAlertTargetLastInfo(guardAlert.alertTarget)
			Capture()
	return NodeState.FAILURE

func Capture():
	guardController.enemyMovement.set_new_target(null)
	guardController.enemyAttack.launch_attack()
