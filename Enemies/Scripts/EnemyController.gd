class_name EnemyController
extends CharacterBody2D

var isInPatrol: bool = true
var isStunned: bool
var characterRef

@export var patrolIndicators: Array[PatrolIndicator]
@export var guardProperties: Array[String]
@export var enemyMovement: EnemyMovement
@export var enemyRotator: EnemyRotator
@export var enemyPatrol: EnemyPatrol
@export var guardStunned: GuardStunned
@export var spriteRef: AnimatedSprite2D

var guardsLookingForMe: Array[GuardResearch]

func _ready():
	spriteRef.play("idle")

func _process(_delta):
	GuardAnimations()

func GuardAnimations():
	if (velocity.x < 0):
		spriteRef.flip_h = true
	else:
		if (velocity.x > 0):
			spriteRef.flip_h = false

func _on_player_character_give_self_reference(reference):
	characterRef = reference


func GetRotator():
	return enemyRotator
