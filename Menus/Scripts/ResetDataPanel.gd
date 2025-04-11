extends Panel

@export var mainMenuPanel: MainMenuPanel

func _ready():
	self.hide()

func _on_yes_button_button_up():
	mainMenuPanel.call_deferred("NewGame")

func _on_no_button_button_up():
	self.hide()
	mainMenuPanel.show()
