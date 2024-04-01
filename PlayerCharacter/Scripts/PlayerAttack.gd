class_name PlayerAttack
extends Node2D

@export var attackPhasesDuration: Array[float]
@export var attackPhasesActivation: Array[bool]
@export var attackHitbox: AttackHitbox
@export var attackSound: AudioStreamPlayer
var attackHitboxInstance: AttackHitbox

var attackLaunched: bool
var attackTimer: float
var currentPhase: int = 0

@export var playerCharacter: PlayerCharacter

func _ready():
	remove_attack_hitbox()

func _process(delta):
	check_for_attack_input()
	attacking(delta)

func add_attack_hitbox():
	self.add_child(attackHitbox)
	attackHitboxInstance = self.get_child(0)
	attackHitboxInstance.characterRef = playerCharacter
	if (!attackSound.playing): attackSound.play()

func remove_attack_hitbox():
	attackHitboxInstance = attackHitbox
	attackHitboxInstance.attack_end()
	self.remove_child(attackHitboxInstance)

func check_for_attack_input():
	if (!attackLaunched && Input.is_action_just_pressed("attack") && !playerCharacter.transformationChangeRef.isTransformed):
		start_attack()

func start_attack():
	startup_attack_phase()
	attackLaunched = true

func startup_attack_phase():
	attackTimer = attackPhasesDuration[currentPhase]
	hitbox_master()
	currentPhase += 1
	end_attack_check()

func hitbox_master():
	if (attackPhasesActivation[currentPhase] == true):
		add_attack_hitbox()
	else:
		remove_attack_hitbox()

func end_attack_check():
	if (currentPhase >= attackPhasesDuration.size()):
		currentPhase = 0
		attackLaunched = false

func attacking(delta):
	if (attackLaunched == true):
		if (attackTimer > 0):
			attackTimer -= delta
		else:
			startup_attack_phase()
