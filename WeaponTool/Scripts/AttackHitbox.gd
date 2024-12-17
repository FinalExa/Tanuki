class_name AttackHitbox
extends Area2D

var hitTargets: Array[Node2D]
var targetsInRange: Array[Node2D]
var characterRef: Node2D
var activated: bool

func _ready():
	EndAttack()

func _process(_delta):
	Attack()

func StartAttack():
	self.show()
	activated = true

func EndAttack():
	hitTargets.clear()
	activated = false
	self.hide()

func Attack():
	if (activated):
		for i in targetsInRange.size():
			if (targetsInRange[i] != null):
				LaunchAttackOnTargetInRange(targetsInRange[i])

func LaunchAttackOnTargetInRange(_targetInRange: Node2D):
	pass

func _on_body_entered(body):
	if (!targetsInRange.has(body)):
		targetsInRange.push_back(body)

func _on_body_exited(body):
	if (targetsInRange.has(body)):
		targetsInRange.erase(body)

func _on_area_entered(area):
	if (area.is_in_group("Interactable") && !targetsInRange.has(area)):
		targetsInRange.push_back(area)

func _on_area_exited(area):
	if (targetsInRange.has(area)):
		targetsInRange.erase(area)
