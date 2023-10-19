class_name GuardAlertValue
extends Label

func updateValue(currentValue, maxValue):
	self.text = str(currentValue, "/", maxValue)
