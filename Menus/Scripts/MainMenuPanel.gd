extends Panel

@export var gameScenePath: String
@export var continuePanel: Panel
@export var optionsPanel: Panel
@export var controlsPanel: Panel
@export var creditsPanel: Panel

func _on_new_game_button_button_up():
	get_tree().change_scene_to_file(gameScenePath)

func _on_continue_button_button_up():
	continuePanel.show()
	self.hide()

func _on_options_button_button_up():
	optionsPanel.show()
	self.hide()

func _on_controls_button_button_up():
	controlsPanel.show()
	self.hide()

func _on_credits_button_button_up():
	creditsPanel.show()
	self.hide()

func _on_quit_button_button_up():
	get_tree().quit()
