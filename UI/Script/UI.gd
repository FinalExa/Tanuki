class_name PlayerHUD
extends Control

signal transformation_name
signal timer_value
signal attack_cooldown

@export var pauseMenuPanel: Panel
@export var dialogueUI: DialogueUI
var isInForcePause: bool

func _ready():
	pauseMenuPanel.hide()
	dialogueUI.hide()

func _process(_delta):
	PauseGame()

func _on_transformation_change_send_transformation_name(trsName):
	emit_signal("transformation_name", trsName)

func _on_transformation_change_send_transformation_active_info(status, timer, duration):
	emit_signal("timer_value", status, timer, duration)

func UpdateAttackCooldown(status, currentFrame, duration):
	emit_signal("attack_cooldown", status, currentFrame, duration)

func PauseGame():
	if (!isInForcePause && Input.is_action_just_pressed("pause")):
		get_tree().paused = !get_tree().paused
		if (get_tree().paused):
			pauseMenuPanel.show()
		else:
			pauseMenuPanel.hide()

func ForcePause():
	isInForcePause = true
	get_tree().paused = true

func EndForcePause():
	isInForcePause = false
	get_tree().paused = false

func Resume():
	get_tree().paused = false
	pauseMenuPanel.hide()

func _on_resume_button_button_up():
	Resume()

func _on_reload_button_button_up():
	Resume()
	get_tree().reload_current_scene()
