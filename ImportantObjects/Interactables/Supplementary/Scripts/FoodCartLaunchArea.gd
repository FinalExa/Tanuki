class_name FoodCartLaunchArea
extends Area2D

@export var foodCart: FoodCart
@export var id: int
var attackHitboxRef: PlayerAttackHitbox

func _process(_delta):
	CheckForPlayerAttack()

func CheckForPlayerAttack():
	if (attackHitboxRef != null && attackHitboxRef.activated && self.visible && foodCart.oldCheckPoint == null):
		foodCart.LaunchTo(id)

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
