extends CharacterBody2D

@export var accelerationPerSecond = 0
@export var maxSpeed = 0
var currentSpeed
var currentDirection = Vector2(0,0)
var inputDirection

func _ready():
	currentSpeed = 0

func get_input():
	inputDirection = Input.get_vector("left", "right", "up", "down")
	
func set_current_speed(delta):
	if (inputDirection == Vector2.ZERO && currentSpeed!=0):
		currentSpeed = 0
	else: if(inputDirection!=Vector2.ZERO):
		currentSpeed += accelerationPerSecond*delta
	velocity = inputDirection*currentSpeed

func _physics_process(delta):
	get_input()
	set_current_speed(delta)
	move_and_slide()
