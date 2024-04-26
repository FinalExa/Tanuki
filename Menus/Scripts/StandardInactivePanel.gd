class_name StandardInactivePanel
extends Panel

@export var mainMenuPanel: Panel

func _ready():
	self.hide()

func _process(delta):
	if (Input.is_action_just_pressed("pause") && self.visible):
		BackToMainMenu()

func BackToMainMenu():
	mainMenuPanel.show()
	self.hide()
