class_name ExecuteAttack
extends Node

@export var attackPhasesDuration: Array[float]
@export var attackPhasesActivation: Array[bool]
@export var attackHitbox: AttackHitbox
@export var attackSound: AudioStreamPlayer
@export var characterRef: Node2D
var attackHitboxInstance: AttackHitbox

var attackLaunched: bool
var attackTimer: float
var currentPhase: int

func _ready():
	currentPhase = 0
	remove_attack_hitbox()

func add_attack_hitbox():
	self.add_child(attackHitbox)
	attackHitboxInstance = self.get_child(0)
	attackHitboxInstance.characterRef = characterRef
	if (!attackSound.playing): attackSound.play()

func remove_attack_hitbox():
	attackHitboxInstance = attackHitbox
	attackHitboxInstance.attack_end()
	self.remove_child(attackHitboxInstance)

func startup_attack_phase():
	attackTimer = attackPhasesDuration[currentPhase]
	hitbox_master()
	currentPhase += 1
	end_attack_check()

func hitbox_master():
	if (attackPhasesActivation[currentPhase]):
		add_attack_hitbox()
	else:
		remove_attack_hitbox()

func end_attack_check():
	if (currentPhase >= attackPhasesDuration.size()):
		currentPhase = 0
		attackLaunched = false

func attacking(delta):
	if (attackLaunched):
		if (attackTimer > 0):
			attackTimer -= delta
		else:
			startup_attack_phase()
