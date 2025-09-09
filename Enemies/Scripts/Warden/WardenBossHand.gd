class_name WardenBossHand
extends Area2D

@export var movementSpeed: float
@export var extraSpeed: float
@export var extraSpeedMinDistance: float
@export var playerHitCooldown: float
var playerHitTimer: float
var wardenBossRef: WardenBossController
var activated: bool
var playerRef: PlayerCharacter
var playerHit: bool

func _ready():
	Deactivate()

func _process(delta):
	TrackPlayer(delta)
	HitCooldown(delta)

func TrackPlayer(delta):
	if (activated):
		if (playerRef == null):
			var wardenPlayerRef: PlayerCharacter = GetWardenPlayerRef()
			if (wardenBossRef.wardenCheck.checkCurrentValue >= wardenBossRef.wardenCheck.checkScreamThreshold && wardenPlayerRef != null):
				self.translate(GetFinalMovementSpeed(wardenPlayerRef) * delta * self.global_position.direction_to(wardenPlayerRef.global_position))
			return
		if (!playerHit):
			playerRef.GameOver(self)
			playerHit = true
			playerHitTimer = playerHitCooldown

func GetFinalMovementSpeed(playerRef: PlayerCharacter):
	var finalSpeed: float = movementSpeed
	if (self.global_position.distance_to(playerRef.global_position) >= extraSpeedMinDistance):
		finalSpeed += extraSpeed
	return finalSpeed

func GetWardenPlayerRef():
	if (wardenBossRef.wardenCheck.raycastResult is PlayerCharacter):
		return wardenBossRef.wardenCheck.raycastResult
	if (wardenBossRef.wardenCheck.playerRef != null && wardenBossRef.wardenCheck.playerSpotted):
		return wardenBossRef.wardenCheck.playerRef
	return null

func HitCooldown(delta):
	if (playerHit):
		if (playerHitTimer > 0):
			playerHitTimer -= delta
			return
		playerHit = false

func Activate(startingPosition: Vector2):
	self.global_position = startingPosition
	self.show()
	activated = true

func Deactivate():
	self.hide()
	playerHit = false
	activated = false

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerRef = null
		playerHit = false
