extends GuardNode

@export var hyottokoController: HyottokoController

func Evaluate(delta):
	if (hyottokoController.isEntranced):
		if (hyottokoController.hyottokoEntranced.expires && hyottokoController.hyottokoEntranced.expireTimer > 0):
			hyottokoController.hyottokoEntranced.expireTimer -= delta
			if (hyottokoController.hyottokoEntranced.expireTimer <= 0):
				hyottokoController.hyottokoEntranced.UnsetEntranced()
				return NodeState.SUCCESS
		return NodeState.FAILURE
	return NodeState.SUCCESS
