class_name TimerBar
extends TextureProgressBar

@export var multiplyOffset: float
@export var startColor: Color
@export var midColor: Color
@export var endColor: Color

func UpdateTimer(timer, duration):
	self.max_value = duration * multiplyOffset
	timer = abs(duration - timer)
	UpdateColor(timer, duration)
	self.value = timer * multiplyOffset

func UpdateColor(timer, duration):
	if (timer >= duration - (duration / 3)):
		tint_progress = startColor
	else:
		if (timer >= duration - ((duration / 3) * 2)):
			tint_progress = midColor
		else:
			tint_progress = endColor
