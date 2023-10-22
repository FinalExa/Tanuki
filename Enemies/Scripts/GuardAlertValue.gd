class_name GuardAlertValue
extends Label

func updateValue(currentValue, maxValue):
	self.text = str("%1.1f" % currentValue, "/", maxValue)
