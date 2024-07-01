class_name PlayerRotator
extends Node2D

@export var upRad = 0
@export var downRad = 0
@export var leftRad = 0
@export var rightRad = 0
@export var playerCollider: CollisionShape2D
var lastDirection: Vector2
var lastSavedDirection: Vector2 = Vector2(0, -1)

func _on_movement_movement_direction(direction):
	horizontalRotation(direction)
	verticalRotation(direction)
	lastDirection = direction
	if (lastDirection != lastSavedDirection && lastDirection != Vector2.ZERO):
		lastSavedDirection = lastDirection
	playerCollider.global_rotation = self.global_rotation

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

func get_current_look_direction():
	return lastSavedDirection
