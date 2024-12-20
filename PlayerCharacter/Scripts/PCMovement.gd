class_name PCMovement
extends Node2D

signal movement_direction

@export var rigidbodyRef: CharacterBody2D
@export var defaultSpeedTier: SpeedTier
@export var playerRef: PlayerCharacter
var currentMaxSpeed: float
var currentAcceleration: float
var currentSpeed: float
var movementEnabled: bool

enum SpeedTier {
	SLOW,
	NORMAL,
	FAST
}

var speedTiersMaxSpeed: Array[float] = [300.0, 500.0, 700.0]
var speedTiersAcceleration: Array[float] = [500.0, 700.0, 900.0]

func _ready():
	currentSpeed = 0
	reset_max_speed()
	EnableMovement()

func _process(_delta):
	SelectAnimation()

func SelectAnimation():
	if (playerRef.velocity != Vector2.ZERO && movementEnabled):
		if (playerRef.velocity.x < 0):
			playerRef.spriteRef.flip_h = true
		else:
			if (playerRef.velocity.x > 0):
				playerRef.spriteRef.flip_h = false
	if (playerRef.transformationChangeRef.isTransformed):
		playerRef.spriteRef.play("hidden")
		return
	if (playerRef.playerInputs.inputDirection != Vector2.ZERO && movementEnabled):
		playerRef.spriteRef.play("running")
		return
	else:
		playerRef.spriteRef.play("idle")

func set_current_speed(delta):
	if (playerRef.playerInputs.inputDirection == Vector2.ZERO && currentSpeed!=0):
		currentSpeed = 0
	else: 
		if(playerRef.playerInputs.inputDirection!=Vector2.ZERO):
			currentSpeed = clamp(currentSpeed + (currentAcceleration * delta), 0, currentMaxSpeed)
	rigidbodyRef.velocity = playerRef.playerInputs.inputDirection * currentSpeed
	emit_signal("movement_direction", playerRef.playerInputs.inputDirection)
	
func reset_max_speed():
	set_max_speed(defaultSpeedTier)
	
func set_max_speed(receivedTier: SpeedTier):
	currentMaxSpeed = speedTiersMaxSpeed[receivedTier]
	currentAcceleration = speedTiersAcceleration[receivedTier]

func _physics_process(delta):
	if (movementEnabled):
		set_current_speed(delta)

func _on_transformation_change_change_speed(receivedTier: SpeedTier):
	set_max_speed(receivedTier)

func _on_transformation_change_reset_speed():
	reset_max_speed()

func DisableMovement():
	movementEnabled = false

func EnableMovement():
	movementEnabled = true

func SetToZero():
	playerRef.velocity = Vector2.ZERO
