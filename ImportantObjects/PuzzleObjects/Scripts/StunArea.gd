extends PuzzleObject

@export var attackTag: String
@export var stunDuration: float
var stunTimer: float
var stunActive: bool

func _process(delta):
	StunTimer(delta)

func StunTimer(delta):
	if (stunActive):
		if (stunTimer > 0):
			stunTimer -= delta
			return
		stunActive = false

func Activation():
	if (get_parent() == null):
		call_deferred("Initialize")

func Deactivation():
	call_deferred("TurnOff")

func Initialize():
	parentRef.add_child(self)
	stunActive = true
	stunTimer = stunDuration

func TurnOff():
	parentRef.remove_child(self)

func _on_body_entered(body):
	if (stunActive):
		if (body.is_in_group("Interactable")):
			body.AttackInteraction(attackTag)
			return
		if (body is EnemyController):
			body.is_damaged(Vector2.ZERO)

func _on_area_entered(area):
	if (area.is_in_group("Interactable")):
		area.AttackInteraction(attackTag)
