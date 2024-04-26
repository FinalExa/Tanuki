extends Label

@export var attackReadyText: String
@export var attackInCooldownText: String

func _ready():
	_on_ui_attack_cooldown(false, 0, 0)

func _on_ui_attack_cooldown(status, currentFrame, duration):
	if (!status):
		self.text = attackReadyText
	else:
		self.text = str(attackInCooldownText, currentFrame, "/", duration)
