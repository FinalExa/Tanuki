extends AttackHitbox

@export var launchDistance: float
@export var launchTime: float

func _on_body_entered(body):
	if (body is PlayerCharacter):
		body.SetLaunched(launchDistance, launchTime)
