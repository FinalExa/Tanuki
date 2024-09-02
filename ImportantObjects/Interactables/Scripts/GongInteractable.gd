extends GenericInteractable

@export var researchLocation: Node2D
var guardsIn: Array[GuardController]

func ExecuteRefEffect(receivedRef):
	if (receivedRef is EnemyController):
		receivedRef.isRepelled = false
		receivedRef.is_damaged(Vector2.ZERO)
		CallGuards(receivedRef)

func CallGuards(guardToExclude: EnemyController):
	var exclude: bool = false
	if (guardToExclude is GuardController):
		exclude = true
	for i in guardsIn.size():
		if (exclude && guardToExclude != guardsIn[i]):
			guardsIn[i].guardResearch.InitializeResearchWithLocation(researchLocation.global_position)

func AddGuardInArea(body):
	if (body is GuardController && !guardsIn.has(body)):
		guardsIn.push_back(body)

func RemoveGuardFromArea(body):
	if (guardsIn.has(body)):
		guardsIn.erase(body)
