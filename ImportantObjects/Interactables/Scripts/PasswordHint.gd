class_name PasswordHint
extends Node2D

@export var labelText: String
@export var labelRef: Label
@export var colorMark: Sprite2D

func _ready():
	labelRef.text = labelText

func ChangeColor(receivedColor: Color):
	colorMark.modulate = receivedColor
