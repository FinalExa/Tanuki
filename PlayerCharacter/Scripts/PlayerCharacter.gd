class_name PlayerCharacter
extends CharacterBody2D

signal transformationInvincibilityInteracted

var sceneRef: Node2D
@export var playerInputs: PlayerInputs
@export var tailRef: Node2D
@export var transformationChangeRef: TransformationChange
@export var movementRef: PCMovement
@export var spriteRef: AnimatedSprite2D
@export var playerHUD: PlayerHUD
@export var playerMovement: PCMovement
@export var playerRotator: PlayerRotator
@export var playerRepelled: PlayerRepelled
@export var playerAttack: PlayerAttack
var buttonInteractionReady: bool
var savePointInteractionReady: bool
var savedSavePoint: SavePoint
var deactivationButton: DeactivationButton
var transformationInvincibility: bool
var isTraveling: bool
var travelId: int

func _ready():
	sceneRef = self.get_parent()
	sceneRef.playerRef = self
	spriteRef.play("idle")
	transformationChangeRef.sceneRef = sceneRef

func _process(_delta):
	if (Input.is_action_just_pressed("interact")):
		activate_interaction()

func _physics_process(_delta):
	move_and_slide()

func set_deactivation_button(deactivationBtn: DeactivationButton):
	buttonInteractionReady = true
	deactivationButton = deactivationBtn

func unset_deactivation_button():
	buttonInteractionReady = false
	deactivationButton = null

func set_save_point(savePoint: SavePoint):
	savePointInteractionReady = true
	savedSavePoint = savePoint

func unset_save_point():
	savePointInteractionReady = false
	savedSavePoint = null

func activate_interaction():
	if (buttonInteractionReady):
		deactivationButton.activate_effect()
	if (savePointInteractionReady):
		savedSavePoint.activate_effect()

func SetLaunched(distance: float, time: float, direction: Vector2):
	playerRepelled.SetRepelled(distance, time, direction)

func GetRotator():
	return playerRotator

func GameOver(receivedNode: Node2D):
	if (transformationInvincibility):
		emit_signal("transformationInvincibilityInteracted", receivedNode)
	else:
		ForceGameOver()

func ForceGameOver():
	playerHUD.GameOverScreen()

func SetTraveling(id: int):
	isTraveling = true
	travelId = id
