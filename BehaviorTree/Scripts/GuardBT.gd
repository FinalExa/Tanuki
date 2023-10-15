extends BehaviorTree

func SetupTree():
	var root: BT_Node
	root = BT_Sequence.new()
	root._setChildren([
		BT_Selector.new()._setChildren([
			BT_Task.new()
		])
	])
