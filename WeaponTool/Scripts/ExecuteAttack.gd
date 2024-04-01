class_name ExecuteAttack
extends Node2D

@export var attackDuration: float
@export var attackPhasesLaunch: Array[float]
@export var attackHitboxes: Array[AttackHitbox]
@export var attackSounds: Array[AudioStreamPlayer]
@export var characterRef: Node2D
var attackHitboxInstance: AttackHitbox

var attackLaunched: bool
var attackTimer: float
var currentPhase: int

func _ready():
	remove_attack_hitboxes()
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
	attackTimer = 0
	execute_attack_phase()

func execute_attack_phase():
	prepare_hitboxes()
	currentPhase += 1

func prepare_hitboxes():
	if (currentPhase > 0):
		remove_attack_hitbox(currentPhase-1)
	add_attack_hitbox(currentPhase)

func end_attack():
	if (currentPhase >= attackPhasesLaunch.size()):
		remove_attack_hitbox(attackPhasesLaunch.size()-1)
		currentPhase = 0
		attackLaunched = false

func attacking(delta):
	if (attackLaunched):
		if (attackTimer < attackDuration):
			attackTimer += delta
			if (currentPhase < attackPhasesLaunch.size() && attackTimer > attackPhasesLaunch[currentPhase]):
				execute_attack_phase()
		else:
			end_attack()

func remove_attack_hitboxes():
	currentPhase = 0
	for i in attackHitboxes.size():
		currentPhase = i
		remove_attack_hitbox(currentPhase)
