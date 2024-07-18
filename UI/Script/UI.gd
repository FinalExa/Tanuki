class_name PlayerHUD
extends Control

signal transformation_name
signal timer_value
signal attack_cooldown

@export var playerInputs: PlayerInputs
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

func _on_transformation_change_send_transformation_name(trsName):
	emit_signal("transformation_name", trsName)

func _on_transformation_change_send_transformation_active_info(status, timer, duration):
	emit_signal("timer_value", status, timer, duration)

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
	get_tree().reload_current_scene()

func _on_options_button_button_up():
	optionsPanel.show()
	pauseMenuPanel.hide()

func _on_controls_button_button_up():
	controlsPanel.show()
	pauseMenuPanel.hide()

func _on_main_menu_button_button_up():
	get_tree().change_scene_to_file(mainMenuPath)

func _on_quit_to_desktop_button_button_up():
	get_tree().quit()

func GameOverScreen():
	ForcePause()
	gameOverSound.play()
	gameOverPanel.show()

func _on_gameover_reload_button_button_up():
	EndForcePause()
	get_tree().reload_current_scene()
