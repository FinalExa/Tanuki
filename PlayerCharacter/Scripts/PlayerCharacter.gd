class_name PlayerCharacter
extends CharacterBody2D

signal set_temp_trs
signal unset_temp_trs
signal give_self_reference

var sceneRef: Node2D
@export var tailRef: Node2D
@export var transformationChangeRef: TransformationChange
@export var movementRef: PCMovement

func _ready():
	sceneRef = self.get_parent()
	transformationChangeRef.sceneRef = sceneRef

func set_trs_ready(trsName, speed, properties):
	emit_signal("set_temp_trs", trsName, speed, properties)

func set_trs_not_ready():
	emit_signal("unset_temp_trs")

func _on_guard_get_character_ref():
	emit_signal("give_self_reference", self)
