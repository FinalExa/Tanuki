class_name TimerText
extends Label

@export var frontText: String

func UpdateTimer(timer, duration):
	timer = abs(duration - timer)
	self.text = str(frontText, duration, "/", snapped(timer, 0.1))
