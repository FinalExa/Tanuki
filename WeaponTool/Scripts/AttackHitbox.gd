class_name AttackHitbox
extends Area2D

var hitTargets: Array[Node2D]
var targetsInRange: Array[Node2D]
var characterRef: Node2D
var activated: bool
@export var lockInPlace: bool
var originalRotationDegrees: float

func _ready():
	EndAttack()
	if (lockInPlace): originalRotationDegrees = self.global_rotation_degrees

func _physics_process(_delta):
	Attack()
	CheckForLockInPlace()

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
			if (targetsInRange[i] != null && VerifyIfTargetIsHittable(targetsInRange[i])):
				LaunchAttackOnTargetInRange(targetsInRange[i])

func CheckForLockInPlace():
	if (lockInPlace): self.global_rotation_degrees = originalRotationDegrees

func VerifyIfTargetIsHittable(target: Node2D):
	if (target != null && !hitTargets.has(target)):
		var space_state = characterRef.get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(characterRef.global_position, target.global_position)
		query.exclude = [characterRef]
		var result = space_state.intersect_ray(query)
		if (result && result != { } && result.collider == target):
			return true
	return false

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
