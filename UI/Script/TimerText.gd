extends Label


func _on_ui_timer_value(status, timer, duration):
	timer = abs(duration-timer)
	if (status):
		self.text = str("Transformed: ", duration, "/", "%1.1f" % timer)
	else:
		self.text = str("Not transformed: ", duration, "/", "%1.1f" % timer)
