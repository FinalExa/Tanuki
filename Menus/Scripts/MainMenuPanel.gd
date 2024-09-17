extends Panel

@export var activeLevelPath: String
@export var gameScenePath: String
@export var continuePanel: Panel
@export var optionsPanel: Panel
@export var controlsPanel: Panel
@export var creditsPanel: Panel

func _ready():
	get_tree().paused = false

func _on_new_game_button_button_up():
	call_deferred("SwapScenes")

func SwapScenes():
	var rootRef = get_tree().root
	var menuRef =  rootRef.get_child(0)
	rootRef.remove_child(menuRef)
	var obj_scene = load(activeLevelPath)
	var sceneMaster: SceneMaster = obj_scene.instantiate()
	sceneMaster.sceneSelector.ChangeScene(gameScenePath)
	rootRef.add_child(sceneMaster)
	menuRef.queue_free()

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
