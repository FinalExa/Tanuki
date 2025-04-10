extends Panel

@export var activeLevelPath: String
@export var gameScenePath: String
@export var continueButton: Button
@export var continueButtonColorOnDisabled: Color
@export var optionsPanel: Panel
@export var controlsPanel: Panel
@export var creditsPanel: Panel

func _ready():
	get_tree().paused = false
	CheckContinueButton()

func NewGame():
	DeleteSaves()
	LoadGameplayMap()

func CheckContinueButton():
	if (DirAccess.dir_exists_absolute("user://saves")):
		var dir = DirAccess.open("user://saves")
		var count: int = 0
		for i in dir.get_files():
			count += 1
		if (count == 0):
			continueButton.modulate = continueButtonColorOnDisabled
			continueButton.disabled = true

func LoadGameplayMap():
	var rootRef = get_tree().root
	var menuRef =  rootRef.get_child(0)
	rootRef.remove_child(menuRef)
	var obj_scene = load(activeLevelPath)
	var sceneMaster: SceneMaster = obj_scene.instantiate()
	sceneMaster.sceneSelector.ChangeScene(gameScenePath)
	rootRef.add_child(sceneMaster)
	menuRef.queue_free()

func DeleteSaves():
	if (DirAccess.dir_exists_absolute("user://saves")):
		var dir = DirAccess.open("user://saves")
		for file in dir.get_files():
			dir.remove(file)

func _on_new_game_button_button_up():
	call_deferred("NewGame")

func _on_continue_button_button_up():
	LoadGameplayMap()

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
