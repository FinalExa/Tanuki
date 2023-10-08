extends Node2D

@export var upRad = 0
@export var downRad = 0
@export var leftRad = 0
@export var rightRad = 0
var lastDirection = Vector2(0,0)

func _on_movement_movement_direction(direction):
	horizontalRotation(direction)
	verticalRotation(direction)
	lastDirection = direction

func verticalRotation(direction):
	if (direction.y != lastDirection.y):
		if(direction.y<0):
			self.rotation_degrees = upRad
		else: 
			if (direction.y>0):
				self.rotation_degrees = downRad

func horizontalRotation(direction):
	if (direction.x != lastDirection.x):
		if(direction.x<0):
			self.rotation_degrees = leftRad
		else: 
			if (direction.x>0):
				self.rotation_degrees = rightRad
