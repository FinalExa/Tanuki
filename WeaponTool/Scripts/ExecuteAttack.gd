class_name ExecuteAttack
extends Node2D

@export var attackDuration: int
@export var attackCooldown: int
@export var attackPhasesLaunch: Array[int]
@export var attackHitboxes: Array[AttackHitbox]
@export var attackSounds: Array[AudioStreamPlayer]
@export var characterRef: Node2D
var frameMaster: FrameMaster
var attackHitboxInstance: AttackHitbox

var attackLaunched: bool
var attackInCooldown: bool
var attackFrame: int
var currentPhase: int

func _ready():
	FindFrameMaster(self)
	RemoveAttackHitboxes()
	currentPhase = 0

func add_attack_hitbox(index):
	if (index < attackHitboxes.size()):
		if (attackHitboxes[index] != null):
			self.add_child(attackHitboxes[index])
			attackHitboxInstance = self.get_child(0)
			attackHitboxInstance.characterRef = characterRef
		if (attackSounds[index] != null && !attackSounds[index].playing): attackSounds[index].play()

func remove_attack_hitbox(index):
	if (index < attackHitboxes.size() && attackHitboxes[index] != null):
		attackHitboxInstance = attackHitboxes[index]
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
			attackLaunched = false
		else:
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
	currentPhase = 0
	for i in attackHitboxes.size():
		currentPhase = i
		remove_attack_hitbox(currentPhase)

func FindFrameMaster(currentNode: Node2D):
	if (currentNode.get_parent() is SceneMaster):
		frameMaster = currentNode.get_parent().frameMaster
		frameMaster.RegisterAttack(self)
	else:
		currentNode = currentNode.get_parent()
		FindFrameMaster(currentNode)
