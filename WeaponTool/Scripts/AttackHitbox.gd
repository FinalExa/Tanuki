class_name AttackHitbox
extends Area2D

var hitTargets: Array[Node2D]
var characterRef: Node2D

func _ready():
	attack_end()

func attack_end():
	hitTargets.clear()
