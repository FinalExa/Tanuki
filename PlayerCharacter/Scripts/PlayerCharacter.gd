class_name PlayerCharacter
extends CharacterBody2D

var sceneRef: Node2D
@export var tailRef: Node2D
@export var transformationChangeRef: TransformationChange
@export var movementRef: PCMovement
var buttonInteractionReady: bool
var deactivationButton: DeactivationButton

func _ready():
	sceneRef = self.get_parent()
	transformationChangeRef.sceneRef = sceneRef

func _process(_delta):
	if (Input.is_action_just_pressed("interact")):
		activate_button()

func set_deactivation_button(deactivationBtn: DeactivationButton):
	buttonInteractionReady = true
	deactivationButton = deactivationBtn

func unset_deactivation_button():
	buttonInteractionReady = false
	deactivationButton = null
	
func activate_button():
	if (buttonInteractionReady):
		deactivationButton.activate_effect()
