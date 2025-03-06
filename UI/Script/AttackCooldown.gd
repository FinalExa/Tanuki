extends TextureProgressBar

@export var attackReadyTexture: Texture2D
@export var attackInCooldownTexture: Texture2D
@export var attackNotAvailableTexture: Texture2D

func _ready():
	ResetUI()

func ResetUI():
	_on_ui_attack_cooldown(false, 0, 1)

func _on_ui_attack_cooldown(status, currentFrame, duration):
	if (!status):
		self.texture_under = attackReadyTexture
		self.value = 0
		self.max_value = 1
	else:
		self.max_value = duration
		self.value = currentFrame
		self.texture_under = attackInCooldownTexture

func SetAvailable(status: bool):
	self.value = 0
	self.max_value = 1
	if (!status):
		self.texture_under = attackNotAvailableTexture
		return
	self.texture_under = attackReadyTexture
