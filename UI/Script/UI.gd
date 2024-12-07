class_name PlayerHUD
extends Control

signal transformation_texture
signal timer_value
signal has_attack
signal attack_cooldown

@export var playerInputs: PlayerInputs
@export var playerRef: PlayerCharacter
@export var timerBar: TimerBar
@export var mainMenuPath: String
@export var pauseMenuPanel: Panel
@export var dialogueUI: DialogueUI
@export var optionsPanel: Panel
@export var controlsPanel: Panel
@export var gameOverPanel: Panel
@export var gameOverSound: AudioStreamPlayer
var isInForcePause: bool

func _ready():
	pauseMenuPanel.hide()
	dialogueUI.hide()
	gameOverPanel.hide()

func _process(_delta):
	PauseGame()

func _on_transformation_change_send_transformation_texture(trsTexture):
	emit_signal("transformation_texture", trsTexture)

func _on_transformation_change_send_transformation_active_info(timer, duration):
	timerBar.UpdateTimer(timer, duration)

func UpdateAttackCooldown(status, currentFrame, duration):
	emit_signal("attack_cooldown", status, currentFrame, duration)

func PauseGame():
	if (!isInForcePause && playerInputs.pauseInput && !(get_tree().paused && !pauseMenuPanel.visible)):
		playerInputs.pauseInput = false
		get_tree().paused = !get_tree().paused
		playerInputs.inputsForceLocked = !playerInputs.inputsForceLocked
		if (get_tree().paused):
			pauseMenuPanel.show()
		else:
			pauseMenuPanel.hide()

func SetPause():
	get_tree().paused = true
	playerInputs.inputsForceLocked = true

func StopPause():
	get_tree().paused = false
	playerInputs.inputsForceLocked = false

func ForcePause():
	isInForcePause = true
	SetPause()

func EndForcePause():
	isInForcePause = false
	StopPause()

func Resume():
	playerInputs.pauseInput = false
	get_tree().paused = false
	playerInputs.inputsForceLocked = false
	pauseMenuPanel.hide()

func _on_resume_button_button_up():
	Resume()

func _on_reload_button_button_up():
	Resume()
	var sceneMaster: SceneMaster = get_tree().root.get_child(0)
	sceneMaster.loadActive = true
	sceneMaster.sceneSelector.ReloadScene()

func _on_options_button_button_up():
	optionsPanel.show()
	pauseMenuPanel.hide()

func _on_controls_button_button_up():
	controlsPanel.show()
	pauseMenuPanel.hide()

func _on_main_menu_button_button_up():
	call_deferred("BackToMainMenu")

func BackToMainMenu():
	var rootRef = get_tree().root
	var sceneMaster: SceneMaster = rootRef.get_child(0)
	var obj_scene = load(mainMenuPath)
	var mainMenu: Control = obj_scene.instantiate()
	rootRef.add_child(mainMenu)
	sceneMaster.queue_free()

func _on_quit_to_desktop_button_button_up():
	get_tree().quit()

func GameOverScreen():
	ForcePause()
	gameOverSound.play()
	gameOverPanel.show()

func _on_gameover_reload_button_button_up():
	var sceneMaster: SceneMaster = get_tree().root.get_child(0)
	sceneMaster.loadActive = true
	EndForcePause()
	gameOverPanel.hide()
	sceneMaster.sceneSelector.ReloadScene()

func _on_transformation_change_send_transformation_has_attack(status):
	emit_signal("has_attack", status)
