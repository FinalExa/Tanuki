class_name ExecuteAttack
extends Node2D

@export var attackDuration: int
@export var attackCooldown: int
@export var attackPhasesLaunch: Array[int]
@export var attackHitboxes: Array[Node2D]
@export var attackSounds: Array[AudioStreamPlayer]
@export var characterRef: Node2D
var frameMaster: FrameMaster
var attackHitboxInstance: Node2D

var attackLaunched: bool
var attackInCooldown: bool
var attackFrame: int
var currentPhase: int

func _ready():
	frameMaster = get_tree().root.get_child(0).frameMaster
	frameMaster.RegisterAttack(self)
	RemoveAttackHitboxes()
	currentPhase = 0

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
		self.remove_child(attackHitboxInstance)

func start_attack():
	attackLaunched = true
	attackFrame = 0
	ExecuteAttackPhase()

func ExecuteAttackPhase():
	PrepareHitboxes()
	currentPhase += 1

func PrepareHitboxes():
	if (currentPhase > 0):
		remove_attack_hitbox(currentPhase-1)
	add_attack_hitbox(currentPhase)

func EndAttack():
	if (currentPhase >= attackPhasesLaunch.size()):
		remove_attack_hitbox(attackPhasesLaunch.size()-1)
		currentPhase = 0
		if (attackCooldown == 0):
			FinalizeAttack()
		else:
			StartCooldown()

func FinalizeAttack():
	attackLaunched = false

func StartCooldown():
	attackInCooldown = true
	attackFrame = 0

func EndCooldown():
	attackInCooldown = false
	attackLaunched = false

func Attacking():
	if (attackLaunched):
		if (!attackInCooldown):
			if (attackFrame < attackDuration):
				attackFrame += 1
				if (currentPhase < attackPhasesLaunch.size() && attackFrame > attackPhasesLaunch[currentPhase]):
					ExecuteAttackPhase()
			else:
				EndAttack()
		else:
			if (attackFrame < attackCooldown):
				attackFrame += 1
			else:
				EndCooldown()

func RemoveAttackHitboxes():
	for i in attackHitboxes.size():
		remove_attack_hitbox(i)
