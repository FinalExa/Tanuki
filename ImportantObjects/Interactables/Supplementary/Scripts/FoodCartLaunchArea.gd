class_name FoodCartLaunchArea
extends Area2D

@export var foodCart: FoodCart
@export var id: int
var attackHitboxRef: PlayerAttackHitbox

func _process(_delta):
	CheckForPlayerAttack()

func CheckForPlayerAttack():
	if (attackHitboxRef != null && attackHitboxRef.activated && self.visible && foodCart.oldCheckPoint == null && !foodCart.cooldownActive):
		LaunchFromClosestToPlayer()

func LaunchFromClosestToPlayer():
	var minDistance: float = -1
	var minId: float = -1
	for i in foodCart.launchAreas.size():
		if (foodCart.launchAreas[i].visible && foodCart.launchAreas[i].attackHitboxRef != null):
			var distance: float = attackHitboxRef.characterRef.global_position.distance_to(foodCart.launchAreas[i].global_position)
			if (minId == -1 || distance < minDistance):
				minId = i
				minDistance = distance
	foodCart.LaunchTo(foodCart.launchAreas[minId].id)

func Activate():
	self.show()

func Deactivate():
	self.hide()

func _on_area_entered(area):
	if (area is PlayerAttackHitbox):
		attackHitboxRef = area

func _on_area_exited(area):
	if (area is PlayerAttackHitbox):
		attackHitboxRef = null
