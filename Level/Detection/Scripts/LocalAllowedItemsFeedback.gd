class_name LocalAllowedItemsFeedback
extends Node2D

func _ready():
	DeactivateFeedback()

func ActivateFeedback():
	self.show()

func DeactivateFeedback():
	self.hide()
