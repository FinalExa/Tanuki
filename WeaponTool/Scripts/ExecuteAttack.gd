class_name ExecuteAttack
extends Node2D

signal on_attack_end

@export var attackDuration: int
@export var attackCooldown: int
@export var attackPhasesLaunch: Array[int]
@export var attackHitboxes: Array[Node2D]
@export var attackSounds: Array[AudioStreamPlayer]
@export var attackMovements: Array[float]
@export var characterRef: Node2D
var frameMaster: FrameMaster
var attackHitboxInstance: Node2D
var movementValue: float
var movementDirection: Vector2

var attackLaunched: bool
var attackInCooldown: bool
var attackFrame: int
var currentPhase: int

func _ready():
	frameMaster = get_tree().root.get_child(0).frameMaster
	frameMaster.RegisterAttack(self)
	RemoveAttackHitboxes()
	currentPhase = 0
	ExtraReadyOperations()
	
func ExtraReadyOperations():
	pass

func AddAttackHitbox(index):
	if (index < attackHitboxes.size()):
		if (attackSounds[index] != null && !attackSounds[index].playing):
			attackSounds[index].play()
		if (attackHitboxes[index] != null):
			attackHitboxInstance = attackHitboxes[index]
			if (attackHitboxInstance is AttackHitbox):
				attackHitboxInstance.StartAttack()
				attackHitboxInstance.characterRef = characterRef
				return
			if (attackHitboxInstance is ObjectSpawner):
				attackHitboxInstance.SpawnObject()
				return
			ActivateOtherTypeOfAttackHitbox()

func RemoveAttackHitbox(index):
	if (index < attackHitboxes.size() && attackHitboxes[index] != null):
		attackHitboxInstance = attackHitboxes[index]
		if (attackHitboxInstance is AttackHitbox):
			attackHitboxInstance.EndAttack()
			return
		if (attackHitboxInstance is ObjectSpawner):
			return
		DeactivateOtherTypeOfAttackHitbox()

func ActivateOtherTypeOfAttackHitbox():
	attackHitboxInstance.show()
	for i in attackHitboxInstance.get_child_count():
		if (attackHitboxInstance.get_child(i) is CollisionShape2D || attackHitboxInstance.get_child(i) is CollisionPolygon2D):
			attackHitboxInstance.get_child(i).disabled = false

func DeactivateOtherTypeOfAttackHitbox():
	attackHitboxInstance.hide()
	for i in attackHitboxInstance.get_child_count():
		if (attackHitboxInstance.get_child(i) is CollisionShape2D || attackHitboxInstance.get_child(i) is CollisionPolygon2D):
			attackHitboxInstance.get_child(i).disabled = true

func start_attack():
	attackLaunched = true
	attackFrame = 0
	characterRef.velocity = Vector2.ZERO
	ExecuteAttackPhase()

func ExecuteAttackPhase():
	PrepareHitboxes()
	currentPhase += 1
	CalculateCurrentAttackMovement(currentPhase - 1)

func PrepareHitboxes():
	if (currentPhase > 0):
		RemoveAttackHitbox(currentPhase - 1)
	AddAttackHitbox(currentPhase)

func EndAttack():
	if (currentPhase >= attackPhasesLaunch.size()):
		RemoveAttackHitbox(attackPhasesLaunch.size() - 1)
		currentPhase = 0
		CheckForCooldown()
		OnAttackEnd()

func CheckForCooldown():
	if (attackCooldown == 0):
		attackLaunched = false
	else:
		StartCooldown()

func ForceEndAttack():
	if (attackLaunched && !attackInCooldown):
		StopAllSounds()
		RemoveAttackHitboxes()
		currentPhase = 0
		CheckForCooldown()
		OnAttackEnd()

func StartCooldown():
	attackInCooldown = true
	attackFrame = 0

func EndCooldown():
	attackInCooldown = false
	attackLaunched = false
	EndCooldownFeedback()

func Attacking():
	if (attackLaunched):
		if (!attackInCooldown):
			if (attackFrame < attackDuration):
				AttackMovement(currentPhase - 1)
				attackFrame += 1
				if (currentPhase < attackPhasesLaunch.size() && attackFrame > attackPhasesLaunch[currentPhase]):
					ExecuteAttackPhase()
			else:
				EndAttack()
		else:
			if (attackFrame < attackCooldown):
				ActiveCooldownFeedback()
				attackFrame += 1
			else:
				EndCooldown()

func RemoveAttackHitboxes():
	for i in attackHitboxes.size():
		RemoveAttackHitbox(i)

func CalculateCurrentAttackMovement(index: int):
	if (attackMovements.size() > 0 && attackMovements[index] != null):
		movementDirection = characterRef.GetRotator().get_current_look_direction()

func AttackMovement(index: int):
	if (attackMovements.size() > 0 && index < attackMovements.size() && attackMovements[index] != null):
		var velocityValue: Vector2 = attackMovements[index] * movementDirection
		characterRef.velocity = velocityValue

func StopAllSounds():
	if (attackSounds.size() > 0):
		for i in attackSounds.size():
			if (attackSounds[i] != null && attackSounds[i].playing):
				attackSounds[i].stop()

func ActiveCooldownFeedback():
	pass

func EndCooldownFeedback():
	pass

func OnAttackEnd():
	pass
