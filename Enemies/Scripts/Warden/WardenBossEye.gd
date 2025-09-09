class_name WardenBossEye
extends Area2D

@export var wardenBossController: WardenBossController
@export var startingStatus: bool
@export var openDuration: float = 5
@export var closeDuration: float = 5
@export var secondaryAnimationTiming: float = 1
@export var spriteRef: AnimatedSprite2D
@export var bodyCollider: CollisionShape2D
@export var directionFeedback: Sprite2D
@export var openIdleAnimation: String
@export var closeIdleAnimation: String
@export var openingAnimation: String
@export var closingAnimation: String
var timer: float
var secondaryPlayed: bool
var currentStatus: bool
var raycastResult: Node2D
var playerRef: PlayerCharacter

func _ready():
	SetStatus(startingStatus)

func _process(delta):
	OpenCloseTimer(delta)

func _physics_process(_delta):
	CheckIfPlayerIsSeen()

func CheckIfPlayerIsSeen():
	if (currentStatus && playerRef != null):
		var space_state = self.get_world_2d().direct_space_state
		raycastResult = null
		var query = PhysicsRayQueryParameters2D.create(self.global_position, playerRef.global_position)
		query.exclude = [bodyCollider]
		var result = space_state.intersect_ray(query)
		if (result && result != { }):
			raycastResult = result.collider
		else:
			raycastResult = null
		if (raycastResult == playerRef && playerRef.transformationChangeRef.get_if_transformed_in_right_zone() != 1):
			if (!wardenBossController.wardenCheck.currentEyes.has(self)):
				wardenBossController.wardenCheck.currentEyes.push_back(self)
		else:
			if (wardenBossController.wardenCheck.currentEyes.has(self)):
				wardenBossController.wardenCheck.currentEyes.erase(self)

func SwapStatus():
	SetStatus(!currentStatus)

func SetStatus(status: bool):
	currentStatus = status
	if (status):
		spriteRef.play(openIdleAnimation)
		directionFeedback.show()
		timer = openDuration
	else:
		spriteRef.play(closeIdleAnimation)
		directionFeedback.hide()
		timer = closeDuration
	secondaryPlayed = false

func OpenCloseTimer(delta):
	if (timer > 0):
		timer -= delta
		SecondaryAnimationCheck()
		if (timer < 0):
			SwapStatus()

func SecondaryAnimationCheck():
	if (!secondaryPlayed):
		if (timer <= secondaryAnimationTiming):
			if (currentStatus): spriteRef.play(closingAnimation)
			else: spriteRef.play(openingAnimation)
			secondaryPlayed = true

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerRef = null
