extends CharacterBody2D

@export var accelerationPerSecond = 0
@export var defaultMaxSpeed = 0
var currentMaxSpeed
var currentSpeed
var inputDirection

func _ready():
	currentSpeed = 0
	reset_max_speed()

func get_input():
	inputDirection = Input.get_vector("left", "right", "up", "down")
	
func set_current_speed(delta):
	if (inputDirection == Vector2.ZERO && currentSpeed!=0):
		currentSpeed = 0
	else: if(inputDirection!=Vector2.ZERO):
		currentSpeed = clamp(currentSpeed+(accelerationPerSecond*delta),0,currentMaxSpeed)
	velocity = inputDirection*currentSpeed
	
func reset_max_speed():
	set_max_speed(defaultMaxSpeed)
	
func set_max_speed(newMaxSpeed):
	currentMaxSpeed = newMaxSpeed

func _physics_process(delta):
	get_input()
	set_current_speed(delta)
	move_and_slide()
