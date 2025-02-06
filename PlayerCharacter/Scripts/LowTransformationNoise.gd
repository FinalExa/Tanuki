extends Area2D

@export var playerRef: PlayerCharacter
@export var transformationChange: TransformationChange
@export var activationMultiplier: float
@export var activationDivider: float
@export var executeTime: float
@export var executeOffTime: float

var enemiesIn: Array[EnemyController]

var active: bool
var executing: bool
var executeTimer: float

func _physics_process(delta):
	CheckIfActive()
	ExecuteTimer(delta)
	ExecuteActive()

func CheckIfActive():
	if (transformationChange.isTransformed):
		if (ConvertTimer() < GetDesiredThreshold()):
			if (!active):
				SwitchExecuting()
			active = true
			return
		active = false
		return
	if (executing): SwitchExecuting()
	active = false

func SwitchExecuting():
	executing = !executing
	if (executing):
		executeTimer = executeTime
		return
	executeTimer = executeOffTime

func ConvertTimer():
	return abs(transformationChange.transformationDuration - transformationChange.transformationTimer)

func GetDesiredThreshold():
	return transformationChange.transformationDuration / activationDivider * activationMultiplier

func ExecuteTimer(delta):
	if (active):
		if (executeTimer > 0):
			executeTimer -= delta
			return
		SwitchExecuting()

func ExecuteActive():
	if (active && executing):
		for i in enemiesIn.size():
			if (VerifyIfTargetIsHittable(enemiesIn[i])):
				ProcessEnemy(enemiesIn[i])

func VerifyIfTargetIsHittable(target: Node2D):
	if (target != null):
		var space_state = playerRef.get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(playerRef.global_position, target.global_position)
		query.exclude = [playerRef]
		var result = space_state.intersect_ray(query)
		if (result && result != { } && result.collider == target):
			return true
	return false

func ProcessEnemy(enemy: EnemyController):
	if (enemy is GuardController):
		ProcessGuard(enemy)
		return

func ProcessGuard(guard: GuardController):
	if (!guard.isInAlert && !guard.isStunned && !guard.isInResearch):
		if (guard.isInPatrol):
			guard.enemyPatrol.stop_patrol()
		if (guard.isChecking):
			guard.guardCheck.StopCheck()
		guard.guardResearch.initialize_guard_research(playerRef)

func CheckIfEnemyEntered(body):
	if (body is EnemyController && !enemiesIn.has(body)):
		enemiesIn.push_back(body)

func CheckIfEnemyExited(body):
	if (body is EnemyController && enemiesIn.has(body)):
		enemiesIn.erase(body)
