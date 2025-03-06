extends StandardInactivePanel

@export var videoPanel: Panel
@export var audioPanel: Panel


func _on_video_button_button_up():
	videoPanel.show()
	self.hide()

func _on_audio_button_button_up():
	audioPanel.show()
	self.hide()

func _on_back_button_button_up():
	BackToPreviousPanel()
