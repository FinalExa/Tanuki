class_name StandardInactivePanel
extends Panel

@export var previousPanel: Panel

func _ready():
	self.hide()

func _process(delta):
	if (self.visible && Input.is_action_just_pressed("pause")):
		BackToPreviousPanel()

func BackToPreviousPanel():
	previousPanel.show()
	self.hide()
