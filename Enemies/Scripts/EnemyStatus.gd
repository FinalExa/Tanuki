class_name EnemyStatus
extends Label

func updateValue(currentValue, maxValue):
	self.text = str("%1.1f" % currentValue, "/", maxValue)

func updateText(textReceived: String):
	self.text = textReceived
