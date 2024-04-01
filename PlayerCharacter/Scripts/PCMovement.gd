class_name PCMovement
extends Node2D

signal movement_direction

@export var rigidbodyRef: CharacterBody2D
@export var accelerationPerSecond = 0
@export var defaultMaxSpeed = 0
@export var normalMovementSound: AudioStreamPlayer
@export var transformedMovementSound: AudioStreamPlayer
@export var playerRef: PlayerCharacter
var currentMaxSpeed
var currentSpeed
var inputDirection

func _ready():
	currentSpeed = 0
	reset_max_speed()

func _process(_delta):
	play_movement_sounds()

func get_input():
	inputDirection = Input.get_vector("left", "right", "up", "down")

func play_movement_sounds():
	if (inputDirection != Vector2.ZERO):
		if (!playerRef.transformationChangeRef.isTransformed):
			if (transformedMovementSound.playing):
				transformedMovementSound.stop()
			if (!normalMovementSound.playing):
				normalMovementSound.play()
		else:
			if (normalMovementSound.playing):
				normalMovementSound.stop()
			if (!transformedMovementSound.playing):
				transformedMovementSound.play()
	else:
		if (normalMovementSound.playing): normalMovementSound.stop()
		if (transformedMovementSound.playing): transformedMovementSound.stop()

func set_current_speed(delta):
	if (inputDirection == Vector2.ZERO && currentSpeed!=0):
		currentSpeed = 0
	else: if(inputDirection!=Vector2.ZERO):
		currentSpeed = clamp(currentSpeed+(accelerationPerSecond*delta),0,currentMaxSpeed)
	rigidbodyRef.velocity = inputDirection*currentSpeed
	emit_signal("movement_direction", inputDirection)
	
func reset_max_speed():
	set_max_speed(defaultMaxSpeed)
	
func set_max_speed(newMaxSpeed):
	currentMaxSpeed = newMaxSpeed

func _physics_process(delta):
	get_input()
	set_current_speed(delta)
	rigidbodyRef.move_and_slide()

func _on_transformation_change_change_speed(receivedSpeed):
	set_max_speed(receivedSpeed)

func _on_transformation_change_reset_speed():
	reset_max_speed()
