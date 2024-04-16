class_name PCMovement
extends Node2D

signal movement_direction

@export var rigidbodyRef: CharacterBody2D
@export var accelerationPerSecond: float
@export var defaultMaxSpeed: float
@export var normalMovementSound: AudioStreamPlayer
@export var transformedMovementSound: AudioStreamPlayer
@export var playerRef: PlayerCharacter
var currentMaxSpeed
var currentSpeed
var inputDirection
var movementEnabled: bool

func _ready():
	currentSpeed = 0
	reset_max_speed()
	EnableMovement()

func _process(_delta):
	play_movement_sounds()
	decide_animation()

func get_input():
	inputDirection = Input.get_vector("left", "right", "up", "down")

func decide_animation():
	if (playerRef.velocity != Vector2.ZERO && movementEnabled):
		if (playerRef.velocity.x < 0):
			playerRef.spriteRef.flip_h = true
		else:
			if (playerRef.velocity.x > 0):
				playerRef.spriteRef.flip_h = false
	if (playerRef.transformationChangeRef.isTransformed):
		playerRef.spriteRef.play("hidden")
		return
	if (inputDirection != Vector2.ZERO && movementEnabled):
		playerRef.spriteRef.play("running")
		return
	else:
		playerRef.spriteRef.play("idle")

func play_movement_sounds():
	if (inputDirection != Vector2.ZERO && movementEnabled):
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
	if (movementEnabled):
		get_input()
		set_current_speed(delta)

func _on_transformation_change_change_speed(receivedSpeed):
	set_max_speed(receivedSpeed)

func _on_transformation_change_reset_speed():
	reset_max_speed()

func DisableMovement():
	movementEnabled = false

func EnableMovement():
	movementEnabled = true
