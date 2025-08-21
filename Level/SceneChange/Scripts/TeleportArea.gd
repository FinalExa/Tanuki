class_name TeleportArea
extends Area2D

@export var pointToTeleport: Node2D
@export var interact: bool
@export var label: Label
@export var interactText: String
@export var teleportDuration: float
var teleportTimer: float
var teleportActive: bool
var playerRef: PlayerCharacter
var sceneSelector: SceneSelector

func _ready():
	if (interact): label.text = interactText
	else: label.text = ""
	teleportTimer = 0
	sceneSelector = get_tree().root.get_child(0).sceneSelector
	label.hide()

func _process(delta):
	Listen()
	TeleportTimer(delta)

func Listen():
	if (playerRef != null && pointToTeleport != null && !teleportActive):
		if (!interact):
			Teleport()
			return
		if (playerRef.playerInputs.talkInput):
			Teleport()

func TeleportTimer(delta):
	if (teleportActive):
		if (teleportTimer > 0):
			teleportTimer -= delta
			return
		TeleportDone()

func Teleport():
	playerRef.playerInputs.inputsLocked = true
	playerRef.playerInputs.SetInputsToZero()
	playerRef.velocity = Vector2.ZERO
	playerRef.playerHUD.loadingScreen.show()
	playerRef.global_position = pointToTeleport.global_position
	teleportTimer = teleportDuration
	teleportActive = true
	sceneSelector.currentScene.set_process(false)

func TeleportDone():
	sceneSelector.currentScene.set_process(true)
	teleportTimer = 0
	playerRef.playerHUD.loadingScreen.hide()
	playerRef.playerInputs.inputsLocked = false
	playerRef = null
	teleportActive = false

func _on_body_entered(body):
	if (playerRef == null && body is PlayerCharacter):
		playerRef = body
		if (interact): label.show()

func _on_body_exited(body):
	if (body is PlayerCharacter && playerRef != null):
		if (!teleportActive): playerRef = null
		if (interact): label.hide()
