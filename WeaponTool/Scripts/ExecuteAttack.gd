class_name ExecuteAttack
extends Node2D

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

func add_attack_hitbox(index):
	if (index < attackHitboxes.size()):
		if (attackHitboxes[index] != null):
			self.add_child(attackHitboxes[index])
			attackHitboxInstance = self.get_child(0)
			if (attackHitboxInstance is AttackHitbox):
				attackHitboxInstance.characterRef = characterRef
		if (attackSounds[index] != null && !attackSounds[index].playing): attackSounds[index].play()

func remove_attack_hitbox(index):
	if (index < attackHitboxes.size() && attackHitboxes[index] != null):
		attackHitboxInstance = attackHitboxes[index]
		if (attackHitboxInstance is AttackHitbox):
			attackHitboxInstance.attack_end()
		if (attackHitboxInstance.get_parent() == self):
			self.remove_child(attackHitboxInstance)

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
		remove_attack_hitbox(currentPhase-1)
	add_attack_hitbox(currentPhase)

func EndAttack():
	if (currentPhase >= attackPhasesLaunch.size()):
		remove_attack_hitbox(attackPhasesLaunch.size() - 1)
		FinalizeAttack()

func FinalizeAttack():
	currentPhase = 0
	if (attackCooldown == 0):
		attackLaunched = false
	else:
		StartCooldown()

func ForceEndAttack():
	RemoveAttackHitboxes()
	FinalizeAttack()

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
		remove_attack_hitbox(i)

func CalculateCurrentAttackMovement(index: int):
	if (attackMovements.size() > 0 && attackMovements[index] != null):
		movementDirection = characterRef.GetRotator().get_current_look_direction()
		if (index == attackPhasesLaunch.size() - 1):
			movementValue = attackMovements[index] / float(attackDuration - attackPhasesLaunch[index])
			return
		if (index < attackPhasesLaunch.size() - 1):
			movementValue = attackMovements[index] / float(attackPhasesLaunch[index + 1] - attackPhasesLaunch[index])

func AttackMovement(index: int):
	if (attackMovements.size() > 0 && index < attackMovements.size() && attackMovements[index] != null):
		var translateValue: Vector2 = movementValue * movementDirection
		characterRef.translate(translateValue)

func ActiveCooldownFeedback():
	pass

func EndCooldownFeedback():
	pass
