class_name TimerBar
extends TextureProgressBar

@export var multiplyOffset: float

func UpdateTimer(timer, duration):
	self.max_value = duration * multiplyOffset
	timer = abs(duration - timer)
	self.value = timer * multiplyOffset
