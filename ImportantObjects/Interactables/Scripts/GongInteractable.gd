extends GenericInteractable

@export var researchLocation: Node2D
@export var stunTier: EnemyStunned.StunTier
var guardsIn: Array[GuardController]

func ExecuteRefEffect(receivedRef):
	if (receivedRef is EnemyController):
		receivedRef.isRepelled = false
		receivedRef.is_damaged(Vector2.ZERO, stunTier)
		CallGuards(receivedRef)

func CallGuards(guardToExclude: EnemyController):
	var exclude: bool = false
	if (guardToExclude is GuardController):
		exclude = true
	for i in guardsIn.size():
		if (exclude && guardToExclude != guardsIn[i]):
			AttractGuard(guardsIn[i])

func AttractGuard(guard: GuardController):
	if (!guard.isStunned && !guard.isInAlert && !guard.isInResearch):
		if (guard.isChecking):
			guard.guardCheck.stop_guardCheck()
		if (guard.isInPatrol):
			guard.enemyPatrol.stop_patrol()
		guard.guardResearch.InitializeResearchWithLocation(researchLocation.global_position)

func AddGuardInArea(body):
	if (body is GuardController && !guardsIn.has(body)):
		guardsIn.push_back(body)

func RemoveGuardFromArea(body):
	if (body is GuardController && guardsIn.has(body)):
		guardsIn.erase(body)
